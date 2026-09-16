#!/bin/sh
# run.sh -- find the commits this workflow run brings, fetch them (commits
# only, no trees or files) and run commit-check.sh on them.
#
#   pull_request  base branch commit .. pull request head, with --dco
#   merge_group   merge group base .. merge group head, with --dco
#   push          previous tip .. new tip; after a force push or on a new
#                 branch, from the parent of the first commit the push brought
#   other events  nothing to check (a notice says so)
#
# Env: TOKEN (read access to the repository), GITHUB_* from the runner.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
event=$GITHUB_EVENT_PATH
dco=
bot=
case "$GITHUB_EVENT_NAME" in
pull_request | pull_request_target)
	base=$(jq -r .pull_request.base.sha "$event")
	head=$(jq -r .pull_request.head.sha "$event")
	dco=--dco
	# A bot cannot certify the Developer Certificate of Origin: only a person
	# can. Dependabot's pull requests are therefore exempt from the sign-off,
	# but never from the attribution rules. The exemption keys on the numeric
	# user id GitHub puts in the event, not on the commit's author name or
	# email, because those are whatever the committer typed.
	if [ "$(jq -r '.pull_request.user.id' "$event")" = 49699333 ]; then
		bot='dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>'
	fi
	;;
merge_group)
	base=$(jq -r .merge_group.base_sha "$event")
	head=$(jq -r .merge_group.head_sha "$event")
	dco=--dco
	;;
push)
	base=$(jq -r .before "$event")
	head=$(jq -r .after "$event")
	;;
*)
	echo "::notice::Commit check: a $GITHUB_EVENT_NAME event brings no commits to check"
	exit 0
	;;
esac

repo=$RUNNER_TEMP/commit-check
rm -rf "$repo"
git init -q "$repo"
cd "$repo"
auth="AUTHORIZATION: basic $(printf 'x-access-token:%s' "$TOKEN" | base64 | tr -d '\n')"
fetch() {
	git -c http.extraHeader="$auth" fetch -q --no-tags --filter=tree:0 \
		"$GITHUB_SERVER_URL/$GITHUB_REPOSITORY.git" "$@"
}
# The whole history of the head, commits only: a few megabytes even for
# pmaports, and no depth limit for a base to fall outside of.
fetch "$head"

if [ "$GITHUB_EVENT_NAME" = push ]; then
	if git merge-base --is-ancestor "$base" "$head" 2>/dev/null; then
		: # a fast-forward: base is already here
	else
		first=$(jq -r '.commits[0].id // empty' "$event")
		count=$(jq '.commits | length' "$event")
		if [ "$count" -ge 2048 ]; then
			# The event payload lists at most 2048 commits.
			echo "::error::Commit check: this push brings more commits than the event lists; check them locally with commit-check.sh"
			exit 1
		fi
		if [ -z "$first" ]; then
			echo "::notice::Commit check: this push brings no new commits"
			exit 0
		fi
		if ! base=$(git rev-parse -q --verify "$first^"); then
			echo "a push of a root commit: checking the whole history"
			exec sh "$here/commit-check.sh" "" "$head"
		fi
	fi
else
	# The base of a pull request or merge group must exist: fail if it cannot
	# be fetched instead of checking nothing.
	fetch "$base"
fi
git rev-parse -q --verify "$base^{commit}" >/dev/null || {
	echo "::error::Commit check: base commit $base is not available"
	exit 1
}
echo "checking $(git rev-parse --short "$base")..$(git rev-parse --short "$head") ${dco:+(with DCO sign-off)}"
# $dco is empty or one word.
# shellcheck disable=SC2086
exec sh "$here/commit-check.sh" "$base" "$head" $dco ${bot:+--bot-author="$bot"}

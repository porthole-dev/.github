#!/bin/sh
# test-commit-check.sh -- run commit-check.sh against throwaway commits.
set -eu
check=$(cd "$(dirname "$0")" && pwd)/commit-check.sh
repo=$(mktemp -d)
trap 'rm -rf "$repo"' EXIT
cd "$repo"
git init -q
git config user.name "Jane Doe"
git config user.email jane@example.org
git commit -q --allow-empty -m base

# expect pass|fail, extra check flags, commit message
expect() {
	result=$1 flags=$2
	git commit -q --allow-empty -m "$3"
	# $flags is empty or one word: unquoted so an empty one passes nothing.
	# shellcheck disable=SC2086
	if sh "$check" HEAD~1 HEAD $flags >/dev/null 2>&1; then got=pass; else got=fail; fi
	if [ "$got" != "$result" ]; then
		echo "FAIL: expected $result, got $got for: $3" >&2
		exit 1
	fi
}

sob="Signed-off-by: Jane Doe <jane@example.org>"
expect pass "" "human change, no trailers"
expect pass "" "change

Assisted-by: Claude"
expect fail "" "change

Generated-by: some-tool 1.0"
expect pass --dco "change

Assisted-by: Claude
$sob"
expect pass --dco "human change

$sob"
expect fail --dco "change without sign-off"
expect fail --dco "change

Signed-off-by: Someone Else <else@example.org>"
expect fail "" "change

Co-authored-by: Claude <noreply@anthropic.com>"
expect fail "" "change

Co-developed-by: GitHub Copilot"
expect fail "" "change

Signed-off-by: Claude <noreply@anthropic.com>"
expect fail "" "change

Signed-off-by: renovate[bot] <bot@example.org>"
expect fail "" "change

Claude-Session: 0123"
expect fail "" "change

🤖 Generated with [Claude Code](https://claude.com/claude-code)"
expect fail "" "change

Assisted-by:"
expect fail "" "change

assisted-by: claude"

# An empty base checks the whole history: the commits above include failures.
if sh "$check" "" HEAD >/dev/null 2>&1; then
	echo "FAIL: an empty base did not check the whole history" >&2
	exit 1
fi

# A merge commit needs no sign-off, but is still checked for wrong attribution.
merge() { # expect, message
	git checkout -q -b side HEAD~1
	git commit -q --allow-empty -m "side

$sob"
	git checkout -q -
	git merge -q --no-ff -m "$2" side
	if sh "$check" HEAD~1 HEAD --dco >/dev/null 2>&1; then got=pass; else got=fail; fi
	git branch -q -D side
	if [ "$got" != "$1" ]; then
		echo "FAIL: expected $1, got $got for merge: $2" >&2
		exit 1
	fi
}
merge pass "Merge pull request #1"
merge fail "Merge pull request #2

Co-authored-by: Claude <noreply@anthropic.com>"
# A bot author is exempt from the sign-off only when --bot-author names it,
# and is never exempt from the attribution rules.
botid='dependabot[bot] <49699333+dependabot[bot]@users.noreply.github.com>'
git checkout -q -b bot HEAD~1
GIT_AUTHOR_NAME='dependabot[bot]' \
GIT_AUTHOR_EMAIL='49699333+dependabot[bot]@users.noreply.github.com' \
	git commit -q --allow-empty -m "ci: bump the actions group"

if sh "$check" HEAD~1 HEAD --dco >/dev/null 2>&1; then
	echo "FAIL: a bot commit passed the DCO without --bot-author" >&2
	exit 1
fi
if ! sh "$check" HEAD~1 HEAD --dco --bot-author="$botid" >/dev/null 2>&1; then
	echo "FAIL: --bot-author did not exempt the bot from the DCO" >&2
	exit 1
fi
if sh "$check" HEAD~1 HEAD --dco --bot-author='someone else <nobody@example.org>' >/dev/null 2>&1; then
	echo "FAIL: --bot-author exempted an author it does not name" >&2
	exit 1
fi

# Dependabot's generated footer is metadata only for the verified bot.
git commit -q --allow-empty --author="$botid" -m "ci: automated update

Signed-off-by: dependabot[bot] <support@github.com>"
if ! sh "$check" HEAD~1 HEAD --dco --bot-author="$botid" >/dev/null 2>&1; then
	echo "FAIL: verified Dependabot footer was rejected" >&2; exit 1
fi
if sh "$check" HEAD~1 HEAD --bot-author='unverified' >/dev/null 2>&1; then
	echo "FAIL: unverified bot footer was accepted" >&2; exit 1
fi

# The exemption covers the sign-off and nothing else.
git commit -q --allow-empty --author="$botid" -m "ci: bump

Co-authored-by: Claude <noreply@anthropic.com>"
if sh "$check" HEAD~2 HEAD --dco --bot-author="$botid" >/dev/null 2>&1; then
	echo "FAIL: --bot-author suppressed the wrong-attribution check" >&2
	exit 1
fi
git checkout -q -
git branch -q -D bot

echo "commit-check: all cases pass"

# Exercise the exact event classifier used by run.sh, including a base repo
# that is itself a fork, missing identity, and the merge queue.
# shellcheck source=actions/commit-check/event-policy.sh
. "$(dirname "$check")/event-policy.sh"
printf '%s\n' '{"pull_request":{"head":{"repo":{"full_name":"org/repo","fork":true}},"base":{"repo":{"full_name":"org/repo"}}}}' > event.json
[ -z "$(event_policy pull_request event.json)" ]
printf '%s\n' '{"pull_request":{"head":{"repo":{"full_name":"other/repo"}},"base":{"repo":{"full_name":"org/repo"}}}}' > event.json
[ "$(event_policy pull_request event.json)" = --dco ]
printf '%s\n' '{}' > event.json
[ "$(event_policy pull_request event.json)" = --dco ]
[ -z "$(event_policy merge_group event.json)" ]
printf '%s\n' 'Co-authored-by: Codex' > body
if sh "$check" --scan body; then exit 1; fi
printf '%s\n' 'Assisted-by: Codex' > body
sh "$check" --scan body
echo 'event policy and body scan: all cases pass'

# The opt-in local hook is the same policy as the CI action.
root=$(cd "$(dirname "$check")/../.." && pwd)
printf '%s\n' 'change' 'Co-authored-by: Codex' > message
if sh "$root/.githooks/commit-msg" message >/dev/null 2>&1; then
	echo "FAIL: local hook accepted forbidden attribution" >&2
	exit 1
fi
printf '%s\n' 'change' '' 'Assisted-by: Codex' > message
sh "$root/.githooks/commit-msg" message
echo 'commit-msg hook: all cases pass'

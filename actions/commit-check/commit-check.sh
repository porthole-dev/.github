#!/bin/sh
# commit-check.sh BASE HEAD [--dco] [--bot-author=NAME <EMAIL>] -- check the
# trailers of the commits in BASE..HEAD, or of all of HEAD's history when BASE
# is empty.
#
# Rejected in every commit, whoever wrote it:
#   - an AI tool named in Co-authored-by: or Co-developed-by:
#   - an AI tool or bot named in Signed-off-by: (a sign-off is a person's
#     Developer Certificate of Origin)
#   - Claude-Session: trailers, AI session URLs, "Generated with [...]" lines
#   - a malformed Assisted-by: or Generated-by: trailer. Both are optional;
#     they are expected when an AI tool was involved (see CONTRIBUTING.md).
# With --dco (pull requests and merge groups), every commit except a merge
# commit also needs a Signed-off-by: matching its author.
# --bot-author exempts exactly one author string from the sign-off, for a bot
# that cannot certify the DCO. The caller must establish that identity from
# something GitHub controls (run.sh uses the event's numeric user id), never
# from the commit itself.
set -eu
base=$1 head=$2
dco=''
bot=''
shift 2
for arg in "$@"; do
	case "$arg" in
	--dco) dco=--dco ;;
	--bot-author=*) bot=${arg#--bot-author=} ;;
	*) echo "commit-check.sh: unknown argument $arg" >&2; exit 2 ;;
	esac
done
ai='claude|anthropic|openai|chatgpt|copilot|gemini|codex|cursor agent|\[bot\]'
wrong="^(co-authored-by|co-developed-by):.*($ai)|^signed-off-by:.*($ai)|^claude-session:|claude\.ai/code/session_|chatgpt\.com/(share|c)/|^.{0,8}generated with \["
fail=0
n=0
range=$head
if [ -n "$base" ]; then range=$base..$head; fi
for c in $(git rev-list "$range"); do
	n=$((n + 1))
	short=$(git rev-parse --short "$c")
	msg=$(git log -1 --format=%B "$c")
	if printf '%s\n' "$msg" | grep -qiE "$wrong"; then
		echo "::error::$short: AI attribution in a trailer or line where it does not belong"
		fail=1
	fi
	if printf '%s\n' "$msg" | grep -iE '^(assisted|generated)-by:' | grep -qvE '^(Assisted|Generated)-by: [^[:space:]]'; then
		echo "::error::$short: malformed Assisted-by: or Generated-by: trailer (expected 'Assisted-by: <tool>')"
		fail=1
	fi
	# A merge commit is made by the merge (GitHub, a merge queue), not written.
	if [ "$dco" = --dco ] && ! git rev-parse -q --verify "$c^2" >/dev/null; then
		author=$(git log -1 --format='%an <%ae>' "$c")
		# An allowlisted bot author, vouched for by the event's numeric user
		# id, is exempt: a sign-off is a person's certification and a bot has
		# no person to make it. Every other rule above still applied.
		if [ -n "$bot" ] && [ "$author" = "$bot" ]; then
			continue
		fi
		if ! git log -1 --format='%(trailers:key=Signed-off-by,valueonly)' "$c" | grep -qxF "$author"; then
			echo "::error::$short: no Signed-off-by: matching the commit author (git commit -s, or git rebase --signoff)"
			fail=1
		fi
	fi
done
echo "checked $n commit(s)"
exit "$fail"

#!/bin/sh
# Queue commits already passed PR policy; only external PRs require DCO.
event_policy() {
	case "$1" in
	pull_request | pull_request_target)
		# Repository identity matters: our base repository may itself be a fork.
		if ! jq -e '.pull_request.head.repo.full_name != null and
			.pull_request.base.repo.full_name != null and
			.pull_request.head.repo.full_name == .pull_request.base.repo.full_name' "$2" >/dev/null; then
			printf '%s\n' --dco
		fi ;;
	esac
}

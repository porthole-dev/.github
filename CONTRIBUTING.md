# Contributing to porthole-dev

Changes go through a reviewed pull request with passing required checks.
Each repository documents its own build and test commands. Keep one topic per PR.

For local commit-message checks in this repository, run
`git config core.hooksPath .githooks`. The hook rejects forbidden attribution
and session links. CI remains the source of truth for whether the contributor
must provide a DCO sign-off; internal branches are exempt and external forks
are checked against the event identity.

## Review and sign-off

Internal branches are certified by a maintainer reviewing and merging them.
Their commits do not require a DCO sign-off. External fork pull requests require
`Signed-off-by:` matching each non-merge commit's human author. The merge queue
checks attribution again; the originating PR already checked external DCO.
Dependabot is exempt from DCO only when identified by GitHub's numeric user ID.

Only a human can certify the Developer Certificate of Origin. An assistant
never adds a sign-off on anyone's behalf. Upstream submissions follow the
receiving project's current rules and are handled by a human.

## AI assistance

Disclose AI help with `Assisted-by: <tool>`. Human-only work needs no disclosure.
Never name an AI as a co-author, co-developer, or signatory. Do not include
session links or generated-with/generated-by lines in commits, PRs, or issues.
The shared commit check validates commits and PR bodies, including body edits.

## Evidence and privacy

Say what was executed and what was only inspected. Hardware claims include the
image hash, installed kernel/packages, test command, date, and redacted evidence.
A package build does not prove a phone feature works.

Do not commit private network identifiers, serials, IMEIs, home paths, credentials,
private logs, or vendor firmware. Public images follow the release firmware and
first-boot policy. Each device-specific service needs systemd and OpenRC support.

## Upstream

Preserve original authorship and licensing. Check the receiving project's AI
policy before proposing upstream work. This organization does not submit
AI-assisted work to postmarketOS or redirect downstream bug reports there.

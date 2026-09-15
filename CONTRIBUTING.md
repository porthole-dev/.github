# Contributing to porthole-dev

This is the default guide for every repository in the organization. A
repository with its own `CONTRIBUTING.md` adds to it.

## Pull requests

- Every change goes through a pull request; nothing is pushed to a default
  branch directly.
- CI must pass. The **Commit check** job enforces the rules below.
- Keep a pull request to one topic. Subjects follow the upstream style of the
  project you are touching, for example `subsystem: what changed`.

## Sign-off (required)

Every commit carries a `Signed-off-by:` line from its author: your
certification under the [Developer Certificate of Origin](https://developercertificate.org/)
that you have the right to submit the change under the repository's licence.

```sh
git commit -s                   # when you commit
git rebase --signoff origin/main   # to sign off commits you already made
```

An AI tool never signs off, because only a person can certify the DCO. If an
assistant prepared your commits, review them and sign them off yourself.
Maintainers can do the same on a pull request with porthole's
`tools/ph-pr-signoff.py OWNER/REPO NUMBER`.

## Disclosing AI assistance

If an AI tool helped write a change, say so with a trailer before your
sign-off:

```
Assisted-by: Claude
Signed-off-by: Your Name <you@example.org>
```

Linux kernel patches use the kernel's documented form, `Assisted-by: LLM`.
Never list an AI as `Co-authored-by:` (that tag is for people), and do not add
session links or "Generated with" lines. Contributions written without AI
need no `Assisted-by:`.

## Never commit private data

No IP or MAC addresses of your own networks, network names, device serials or
IMEIs, home directory paths, tokens, keys, or vendor firmware blobs. Redact to
a stable placeholder instead of deleting the evidence.

## Upstream projects

Patches go upstream only to projects that accept AI-assisted work, under their
own rules, and are always sent by a person. Nothing from this organization is
submitted to postmarketOS, whose policy does not accept AI-generated
contributions. Please do not report issues with these ports to postmarketOS.

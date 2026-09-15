# Security policy

## Reporting a vulnerability

Please report security issues privately through GitHub's
**Report a vulnerability** button on the affected repository's *Security* tab
(private vulnerability reporting). If that is unavailable, email
jertlok@proton.me. Do not open a public issue for a vulnerability.

You can expect an acknowledgement within a week. Fixes are released as soon as
they are ready, and you are credited unless you ask not to be.

## What is in scope

- **porthole**: running untrusted content from a device profile or config file,
  credentials or keys leaking into logs or committed files, and anything a
  malicious pull request could run on a reviewer's machine.
- **pmos-packages and the package CI**: anything that could get an unsigned or
  tampered package, or a package built from unreviewed code, into the signed
  repository.
- **Apps** (obscura, tap, phosh-nfc-quick-setting): the usual application
  security issues.

Repositories may document additional scope and known non-issues in their own
`SECURITY.md`.

## Supported versions

Only the latest release of each application and the current state of each
default branch receive fixes.

## No warranty

This software is provided "as is", without warranty of any kind; see each
repository's licence. Flashing or installing it can brick a device or erase
data.

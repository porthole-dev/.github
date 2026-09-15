# porthole-dev

Bringing phones back to life on mainline Linux.

porthole-dev builds the tools, packages and patches to run
[postmarketOS](https://postmarketos.org) on phones their vendors stopped
supporting, starting with the Google Pixel 2 XL (taimen): mainline kernel,
cameras, fingerprint unlock, NFC and a working GPU stack.

> **Unofficial.** Not affiliated with or endorsed by postmarketOS, Alpine Linux,
> Google or Qualcomm. Report problems here, not to them.
>
> **AI-assisted.** Much of this work is developed with an AI coding assistant
> and disclosed with an `Assisted-by:` trailer on every commit. Every change is
> reviewed and signed off by a human, who is responsible for it. Each
> repository's `AI.md` explains how.

## Repositories

| repository | what it is |
| --- | --- |
| [porthole](https://github.com/porthole-dev/porthole) | The bring-up toolkit: sandboxed builds, safe flashing, device checks, and a knowledge base of what bring-up taught us. Start here. |
| [pmaports](https://github.com/porthole-dev/pmaports) | Our fork of pmaports: the device port and every package it needs patched. |
| [pmbootstrap](https://github.com/porthole-dev/pmbootstrap) | pmbootstrap with fast, correct cross-compilation for Rust and meson projects. |
| [pmos-packages](https://github.com/porthole-dev/pmos-packages) | The signed apk repository CI publishes from pmaports: prebuilt packages for pmbootstrap and for the phone. |
| [obscura](https://github.com/porthole-dev/obscura) | A camera app built on libcamera, with every manual control the sensor has. |
| [tap](https://github.com/porthole-dev/tap) | Read and write NFC tags through the NFC portal. |
| [phosh-nfc-quick-setting](https://github.com/porthole-dev/phosh-nfc-quick-setting) | An NFC toggle for phosh's quick settings. |

## How the pieces fit

1. Packages are developed in **pmaports** on the `taimen-bringup` branch.
2. Every pull request is built and checked by CI; every merge publishes the
   forked packages that have no prebuilt yet to **pmos-packages**.
3. **pmbootstrap** (and **porthole** on top of it) uses that repository as a
   binary mirror, so nobody rebuilds what CI already built, and a phone
   installed from it keeps getting updates with `apk upgrade`.
4. Apps release by tag; CI opens the matching pmaports update automatically.

## Contributing

Human and AI-assisted contributions are both welcome. Every commit needs a
`Signed-off-by:` from its author (the Developer Certificate of Origin); disclose
AI help with `Assisted-by:`. See
[CONTRIBUTING.md](https://github.com/porthole-dev/.github/blob/main/CONTRIBUTING.md).

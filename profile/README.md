# porthole-dev

Bringing phones back to life on mainline Linux.

[Website](https://porthole-dev.github.io/porthole/) ·
[Downloads](https://porthole-dev.github.io/porthole/downloads/) ·
[Device support](https://porthole-dev.github.io/porthole/devices/)

porthole-dev builds tools, packages and patches for [Nura](https://nura.eco),
starting with an experimental mainline Linux port for the Google Pixel 2 XL
(`taimen`). Hardware support is published only when a dated report verifies it
on a specific image.

> **Unofficial.** Not affiliated with or endorsed by Nura, Alpine Linux,
> Google or Qualcomm. Report problems here, not to them.
>
> Each repository's `AI.md` explains its assistance and review policy.

## Repositories

| repository | what it is |
| --- | --- |
| [porthole](https://github.com/porthole-dev/porthole) | The bring-up toolkit: sandboxed builds, safe flashing, device checks, and a knowledge base of what bring-up taught us. Start here. |
| [pmaports](https://github.com/porthole-dev/pmaports) | Our fork of pmaports (upstream Git namespace retained): the device port and every package it needs patched. |
| [pmbootstrap](https://github.com/porthole-dev/pmbootstrap) | pmbootstrap with fast, correct cross-compilation for Rust and meson projects. |
| [pmos-packages](https://github.com/porthole-dev/pmos-packages) | The signed apk repository CI publishes from pmaports: prebuilt packages for pmbootstrap and for the phone. |
| [obscura](https://github.com/porthole-dev/obscura) | A camera app built on libcamera, with every manual control the sensor has. |
| [tap](https://github.com/porthole-dev/tap) | Read and write NFC tags through the NFC portal. |
| [phosh-nfc-quick-setting](https://github.com/porthole-dev/phosh-nfc-quick-setting) | An NFC toggle for phosh's quick settings. |

## Start here

- [Porthole](https://github.com/porthole-dev/porthole): device status, build
  guidance and release policy. Experimental ports may have no image.
- [Packages](https://github.com/porthole-dev/pmos-packages): signed APK repositories.

Package recipes live in pmaports. CI checks changed packages; approved publication
updates the signed repository. Image candidates are assembled and verified
separately. Hardware validation is recorded against the exact image hash.

## Contributing

Use the [organization policy](https://github.com/porthole-dev/.github/blob/main/CONTRIBUTING.md). Internal changes need maintainer
review; external fork PRs additionally require their human authors' DCO sign-offs.
Disclose AI assistance with `Assisted-by:`. See each repository's `AI.md`.

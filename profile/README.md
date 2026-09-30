<div align="center">

# Porthole Dev

### A longer life for the phones we already own.

Mainline Linux bring-up, signed packages, and practical tools for community-maintained phones.

**[Explore Porthole](https://porthole-dev.github.io/porthole/)** · **[Device downloads](https://porthole-dev.github.io/porthole/images/)** · **[Device support](https://porthole-dev.github.io/porthole/devices/)**

</div>

---

We work on the whole path from a device port to a usable phone: kernels and
packages, reproducible builds, installation tools, and mobile applications.
Our first target is the **Google Pixel 2 XL (`taimen`)**, running mainline Linux
with [Nura](https://nura.eco).

**The Pixel 2 XL port is experimental.** Published candidates are available from
the website. Hardware support is recorded against the exact image tested;
check the [device directory](https://porthole-dev.github.io/porthole/devices/)
before installing. Release availability and test results refresh from the
project's release data, rather than a manually maintained list here.

## Find your starting point

| I want to… | Start here |
| --- | --- |
| Try an image | [Downloads and installation](https://porthole-dev.github.io/porthole/images/) |
| Find a package | [Search the signed package catalog](https://porthole-dev.github.io/porthole/packages/) |
| Port or debug a device | [Bring-up toolkit](https://github.com/porthole-dev/porthole) · [Knowledge base](https://porthole-dev.github.io/porthole/brain/) |
| Build and publish | [Developer pipelines](https://porthole-dev.github.io/porthole/pipelines/) |
| Help the project | [Contributing](https://github.com/porthole-dev/.github/blob/main/CONTRIBUTING.md) |

## Platform and tooling

- **[Porthole](https://github.com/porthole-dev/porthole)** — the bring-up toolkit, device checks, documentation, and shared knowledge.
- **[pmaports](https://github.com/porthole-dev/pmaports)** — device and package recipes, mainline patches, and image builds.
- **[pmbootstrap](https://github.com/porthole-dev/pmbootstrap)** — build tooling with cross-compilation improvements.
- **[pmos-packages](https://github.com/porthole-dev/pmos-packages)** — signed APK repositories for builders and phones.
- **[firmware-google-taimen](https://github.com/porthole-dev/firmware-google-taimen)** — device firmware packaging.

## Applications

- **[Obscura](https://github.com/porthole-dev/obscura)** — a libcamera application with manual camera controls.
- **[Tap](https://github.com/porthole-dev/tap)** — read and write NFC tags through the NFC portal.
- **[Phosh NFC quick setting](https://github.com/porthole-dev/phosh-nfc-quick-setting)** — an NFC toggle for Phosh.

## Work with us

Report problems in the relevant repository with your device, image revision,
and reproduction steps. Follow the [contribution policy](https://github.com/porthole-dev/.github/blob/main/CONTRIBUTING.md)
for patches and each repository's `SECURITY.md` for private vulnerability reports.
Internal changes require maintainer review; external fork pull requests also
require the human author's DCO sign-off. Disclose AI assistance with `Assisted-by:`;
each repository's `AI.md` explains the assistance and review policy.

<sub>Independent community work. Not affiliated with or endorsed by Nura, Alpine Linux, Google, or Qualcomm.</sub>

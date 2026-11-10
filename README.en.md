# GSM2SIP MediaTek adaptation

[中文](README.md) | English

GSM2SIP adaptation tools and module templates for MT6893.

[Download APK](https://github.com/1Fann/gsm2sip-mtk/releases/latest) · [Release notes](https://github.com/1Fann/gsm2sip-mtk/releases)

## Features

- BakaSU global-mount root shell compatibility.
- An experimental MT6893 cellular-audio profile.
- Pinned-source verification, repeatable builds and minimal privileged-module templates.

## Getting started

Experimental target: MT6893/chopin, Android 12+ and BakaSU/KernelSU, not all MediaTek devices. The APK requires a privileged module. Cellular two-way audio and SIM-specific outgoing calls remain unverified.

Download the release, follow the installation guide, grant the requested permissions and configure your own account locally. Keep the same signing identity when upgrading to retain app data.

## Documentation

- [Build and installation](docs/BUILD.md)
- [Adaptation scope](docs/CHANGES.md)
- [Distribution and licensing](NOTICE.md)

## License

The adaptation toolkit is MIT-licensed; upstream GSM2SIP licensing applies separately. Authorized APKs are distributed through Releases. This does not relicense all upstream code as MIT; see [NOTICE.md](NOTICE.md).

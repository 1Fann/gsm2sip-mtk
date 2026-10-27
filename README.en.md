# GSM2SIP MediaTek adaptation

[简体中文](README.md) · [Change scope](docs/CHANGES.md) · [Build and installation](docs/BUILD.md) · [License scope](NOTICE.md)

Repository: `1Fann/gsm2sip-mtk`. The current target is MT6893; support for all MediaTek SoCs is not implied.

Prepare a local build of pinned [GSM2SIP](https://github.com/OriginStackHQ/GSM2SIP)
with only **BakaSU root-shell support** and an **experimental MT6893 audio profile**.

**This repository open-sources the adaptation tools and module templates. Upstream has no declared license, so neither its source snapshot nor derived APKs are redistributed. Releases contain this toolkit's source only.**

## Exactly two runtime adaptations

| File | Adaptation |
|---|---|
| `RootShell.kt` | Use `su -M` for persistent and one-shot root commands to access BakaSU's global mount namespace. |
| `DeviceProfile.kt` | Select an experimental Android telephony audio profile for `mt6893`, retaining upstream capture fallbacks. |

Every other upstream Kotlin, manifest and resource file remains byte-identical.
Separate build-metadata changes select API 35, Gradle 9.1.0, optional private
signing and a distinct version identifier.

The earlier test build's permission-controller restrictions, preservation of
default SMS notifications, autoconnect-off default, deferred permission/role
requests and microphone-fallback restriction have all been removed.
**Upstream permission-controller handling, SMS-notification handling, autoconnect
defaults and capture fallbacks therefore apply again.** Existing saved settings
are not reset by restoring defaults.

## Validation status

- Target: `chopin / MediaTek MT6893`, Android 12+, BakaSU/KernelSU.
- The inspected phone runs an Android 17 port. Check the SoC and codename rather than relying on its marketing name.
- The gateway has registered to a local SIP server, and an iPhone/Asterisk echo test has passed.
- **Cellular calls, SIM-specific outgoing calls and MT6893 two-way cellular audio remain unverified.** An Asterisk echo test does not exercise the cellular audio bridge.
- No SIP server, personal domain, credentials, SIM numbers or device logs are included.

## Prepare and build locally

Requirements: PowerShell 7, JDK 21, Android SDK platform 35 and Gradle 9.1.0.

```powershell
pwsh ./tools/Prepare-Source.ps1
pwsh ./tools/Build.ps1 -SdkDir /path/to/android-sdk
```

Preparation downloads the pinned archive directly from upstream and verifies
its SHA256. It is repeatable and rejects unexpected local source edits.
Fetched source and local build outputs stay under ignored `.work/` and must
not be committed or redistributed.

Release builds are unsigned by default. Follow [the build guide](docs/BUILD.md)
to supply your own signing key, then create a local module:

```powershell
pwsh ./tools/Build-Module.ps1 -ApkPath /path/to/your-signed.apk
```

The module contains only the privileged APK and permission allowlist. It adds
no global audio properties, boot-time forced grants or SMS rate changes.
Root, a compatible mounting component and a reboot are still required for
initial installation.

## Provenance and version

- Upstream: `OriginStackHQ/GSM2SIP`
- Pinned commit: `0b0a1a68a6e66c8291e053cd70430639df020877`
- Local APK version: `1.2.0-bakasu-mt6893.2` / `427`
- Original toolkit: MIT; upstream licensing is separate. See [NOTICE](NOTICE.md).

No signing keys are distributed. Preserve your own key for future upgrades;
Android cannot directly replace an existing package with a different signer.

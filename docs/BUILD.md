# Build and installation / 构建与安装

## Prerequisites / 前提

Use PowerShell 7, JDK 21 and Android SDK platform 35. The Android plugin may
request Build Tools 36.0.0. Install SDK components through the official Android
SDK manager. Set `JAVA_HOME` to your JDK installation.

使用 PowerShell 7、JDK 21 和 Android SDK 平台 35。构建可能需要 Build Tools 36.0.0；
请使用 Android 官方 SDK 管理器安装，并设置 `JAVA_HOME`。

## Source preparation / 准备源码

```powershell
pwsh ./tools/Prepare-Source.ps1
```

An existing, unmodified upstream ZIP can be supplied without another download:

已有固定提交的原始归档时，可跳过重复下载；仍然会校验 SHA256：

```powershell
pwsh ./tools/Prepare-Source.ps1 -ArchivePath /path/to/upstream.zip
pwsh ./tools/Prepare-Source.ps1  # checks repeatability / 再次执行核对幂等性
pwsh ./tools/Test-Adaptation.ps1
```

The archive URL, commit, checksum and baseline file hashes live in `upstream.json`.
Unexpected local Kotlin edits are rejected. Do not point this tool at a source
tree you are independently editing; use the generated `.work/src` checkout.

下载地址、固定提交、归档校验值及基准文件校验值位于 `upstream.json`。
不符合预期的本地 Kotlin 修改会被拒绝，请使用独立的 `.work/src` 生成目录。

## Build / 编译

```powershell
pwsh ./tools/Build.ps1 -SdkDir /path/to/android-sdk
```

To reuse an installed Gradle, pass `-GradleCommand /path/to/gradle`.
Use `-Offline` only after all required Gradle/Maven dependencies are cached.

可用 `-GradleCommand` 指定已有 Gradle 命令。所有依赖已缓存时，才使用 `-Offline`。

## Signing / 签名

The toolkit does not ship or generate a shared signing key. With no signing
environment variables, release builds remain unsigned. To install a release,
provide your own keystore through these variables in your local environment:

工具不附带或生成公共签名密钥。未设置签名环境变量时，发布构建不签名。
需要安装时，在本地环境配置自己的签名信息：

| Variable / 变量 | Meaning / 含义 |
|---|---|
| `GSM_KEYSTORE` | Private keystore path / 私钥文件路径 |
| `GSM_STORE_PASSWORD` | Keystore password / 私钥库密码 |
| `GSM_KEY_ALIAS` | Alias, default `gsm2sip` / 别名，默认 `gsm2sip` |
| `GSM_KEY_PASSWORD` | Optional distinct key password / 可选的独立私钥密码 |

Enter secrets locally using a hidden prompt or your secret manager. Do not put
them in command history, source, issues or workflow files. Keep your keystore
outside this repository and retain it for updates.

通过本地隐藏输入或密码管理工具设置秘密，不要写入命令历史、源码、Issue 或工作流文件。
私钥应保存在本仓库之外，并保留用于后续更新。

Outputs are under `.work/src/app/build/outputs/apk/release/`.
Local signing must match an existing installation if you want to preserve its data.

产物位于上述目录。若要覆盖已有安装并保留数据，必须使用原安装的签名。

## Local module / 本地模块

```powershell
pwsh ./tools/Build-Module.ps1 -ApkPath /path/to/your-signed.apk
```

Output: `.work/dist/gsm2sip-bakasu-mt6893-1.2.0.2.zip`.
The ZIP contains exactly four files: module metadata, installer, privileged
permission XML and the APK. It requires KernelSU/BakaSU, ARM64, MT6893 and API 31+.

ZIP 严格包含模块信息、安装脚本、权限 XML 和 APK 四个文件。
安装器检查 KernelSU/BakaSU、ARM64、MT6893 与 API 31 及以上。

For a first installation, use a compatible mounting metamodule, install the
local module through the root manager, and reboot. Then open GSM2SIP and grant
the requested runtime permissions and Root access. Follow the app's upstream
requests for phone roles and battery settings when configuring the gateway.

首次安装需准备兼容的挂载组件，通过 Root 管理器安装本地模块并重启。
随后打开 GSM2SIP，手动授予运行时权限和 Root。配置网关时，按 App 上游流程处理
默认电话应用和电池设置请求。不要把本地签名私钥、SIP 账号或号码打包进模块。

## Validation and rollback / 验证与回退

For an authorized signed release, stage the APK before committing:

有分发授权的签名 APK 可通过下列命令准备发布：

```powershell
pwsh ./tools/Stage-Release.ps1 -ApkPath /path/to/your-signed.apk
```

Commit `releases/` and use a commit message beginning with `Release ` on `main`.
Actions reassembles the binary inputs, verifies the complete APK SHA256, and
uploads `gsm2sip-mtk.apk` plus `SHA256SUMS` through GitHub's Release asset API.

将 `releases/` 提交到 `main`，提交说明以 `Release ` 开头。
Actions 会重组二进制输入、校验完整 APK 的 SHA256，并通过 Release 资产接口
上传 `gsm2sip-mtk.apk` 和 `SHA256SUMS`。

First verify SIP registration, then test one controlled cellular call and both
audio directions. An iPhone/Asterisk echo test proves only the SIP media path.
Keep your previous signed APK/module locally. Do not uninstall the package just
to bypass a signer mismatch; that removes its private configuration.

先验证 SIP 注册，再进行一通受控蜂窝通话并检查双方声音。回声测试只验证 SIP 媒体路径。
旧签名 APK/模块应在本地留备份。不要为了绕过签名不匹配而直接卸载，这会删除私有配置。

To stop the gateway, use its own Stop control. To disable its system privileges,
disable `gsm2sip_bakasu_test` in the root manager and reboot. Restore your earlier
default phone app if you had changed it. A mounting component should only be
removed after confirming that no other module depends on it.

停止网关使用 App 的停止按钮；停用系统特权则在 Root 管理器中停用该模块并重启。
若曾切换默认电话应用，按需还原。移除挂载组件前应确认没有其他模块依赖。

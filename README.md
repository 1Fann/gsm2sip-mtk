# GSM2SIP 联发科适配

[English](README.en.md) · [改动范围](docs/CHANGES.md) · [构建与安装](docs/BUILD.md) · [授权范围](NOTICE.md)

仓库：`1Fann/gsm2sip-mtk`。当前适配目标为 MT6893，不代表支持全部联发科芯片。

用于从固定版本的 [GSM2SIP](https://github.com/OriginStackHQ/GSM2SIP)
生成仅包含 **BakaSU Root Shell 适配**和 **MT6893 实验性音频配置**的本地构建。

**本仓库开源的是适配工具和模块模板。上游未声明许可证，因此不重新发布上游源码或衍生 APK；Releases 也只提供本仓库工具的源码。**

## 只保留两项运行时改动

| 文件 | 改动 |
|---|---|
| `RootShell.kt` | 持久和一次性 Root Shell 使用 `su -M`，让 BakaSU 命令进入全局挂载空间。 |
| `DeviceProfile.kt` | 为 `mt6893` 添加实验性系统通话音频配置，保留上游音频采集回退逻辑。 |

其余上游 Kotlin、AndroidManifest 和资源文件逐字节保持不变。
构建元数据另有调整：API 35、Gradle 9.1.0、本地可选签名和独立版本号。

之前测试版增加的权限管理器处理限制、短信通知保留、默认关闭自动连接、
延后权限请求、禁止环境麦克风回退等改动，均不再包含。
**这意味着新版恢复上游的权限管理器处理、短信通知处理、自动连接默认值和音频回退行为。**
恢复默认值不会重置已经保存的个人设置。

## 验证状态

- 适配目标：`chopin / MediaTek MT6893`，Android 12 及以上，BakaSU/KernelSU。
- 实机环境为 Android 17 移植系统；手机营销名称可能对应不同硬件，以 SoC 和代号为准。
- GSM2SIP 网关曾完成局域网 SIP 注册；iPhone 与本机 Asterisk 的回声测试已通过。
- **真实蜂窝通话、SIM 指定呼出和 MT6893 双向通话音频尚未验证。** 回声测试不会经过蜂窝音频通道。
- 不含 SIP 服务器、域名、账号、密码、SIM 号码或任何个人设备日志。

## 本地准备与构建

需要 PowerShell 7、JDK 21、Android SDK 平台 35，以及 Gradle 9.1.0。

```powershell
pwsh ./tools/Prepare-Source.ps1
pwsh ./tools/Build.ps1 -SdkDir /path/to/android-sdk
```

源码直接从上游固定提交下载，并校验归档 SHA256。
准备命令可重复执行；不符合预期的本地源码改动会使适配失败，而不是被静默覆盖。
生成的源码和构建产物都位于 `.work/`，不应提交或重新分发。

发布版默认不签名。需要在手机安装时，按照 [构建说明](docs/BUILD.md) 使用自己的私钥签名，
再生成本地模块：

```powershell
pwsh ./tools/Build-Module.ps1 -ApkPath /path/to/your-signed.apk
```

模块仅包含 APK 和特权权限清单，不附加全局音频属性、开机授权脚本或短信限额修改。
安装仍需 Root、兼容的挂载组件及重启；具体步骤见构建说明。

## 来源与版本

- 上游：`OriginStackHQ/GSM2SIP`
- 固定提交：`0b0a1a68a6e66c8291e053cd70430639df020877`
- 本地 APK：`1.2.0-bakasu-mt6893.2` / `427`
- 原始适配工具：MIT；上游授权单独适用，见 [NOTICE](NOTICE.md)。

私钥不随项目发布。不同签名的 APK 不能直接覆盖已有安装；更新时请保留自己的签名密钥。

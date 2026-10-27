# Change scope / 改动范围

## Runtime / 运行时代码

1. **BakaSU:** add `-M` to the persistent `su` process and both one-shot fallbacks
   in `RootShell.kt`.
2. **MT6893:** add a profile-selection branch and a `generic().copy(...)` profile
   in `DeviceProfile.kt`. It uses Android telephony RX/TX routes with no
   guessed mixer controls. Upstream capture-source fallback remains intact.

1. **BakaSU：**为 `RootShell.kt` 的持久 `su` 进程及两个一次性回退增加 `-M`。
2. **MT6893：**在 `DeviceProfile.kt` 增加选择分支及实验性音频配置，使用系统通话
   RX/TX 路径，不写入猜测的 mixer 控制项，并保留上游采集源回退。

There is no `digitalOnlyCapture` field or extra filter in `RtpSession.kt`.
`MainActivity.kt`, `BootReceiver.kt`, `GatewayService.kt`, `ConfigController.kt`,
the manifest and string resources are unchanged from the pinned upstream.

不再包含 `digitalOnlyCapture` 字段或 `RtpSession.kt` 中的额外过滤。
首页、开机接收器、网关服务、设置界面、权限清单和名称资源均恢复固定上游版本。

## Build metadata / 构建元数据

- `app/build.gradle.kts`: API 35; version 427; environment-based optional release signing.
- `gradle-wrapper.properties`: Gradle 9.1.0 instead of upstream's 9.7.1 URL.
- A local SDK path is generated only inside ignored `.work/src/local.properties`.

These are build/identity changes, not additional gateway behavior patches.
The original app label and package ID `com.callagent.gateway` remain unchanged.

以上属于构建和版本识别设置，不增加网关行为改动。App 名称恢复上游，包名保持不变。

## Installation / 安装方式

The independently written module template installs the privileged APK and four
call/audio permissions. It does not copy upstream's other module scripts,
properties, overlays or audio-tool binaries. Limiting module contents is an
installation choice, separate from the two APK runtime adaptations.

自行编写的模块模板只安装特权 APK 和四项通话/音频权限。不复制上游模块的其他脚本、
属性、覆盖层或音频工具二进制。这属于安装范围选择，与 APK 的两项适配分别说明。

## Audit / 核对

`Test-Adaptation.ps1` compares prepared files to the verified upstream archive.
Unexpected differences fail the check. Re-running preparation also checks
that the two adapted files still match the expected generated content.

核对工具将准备后的文件与已校验上游归档逐一比较，遇到额外差异立即失败。
重复执行准备命令还会检查两项适配文件是否符合生成结果。

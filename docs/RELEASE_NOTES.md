## 中文

- 仅保留 BakaSU 全局挂载 Root Shell 与 MT6893 实验性音频配置两项运行时适配。
- 其余权限、通知、自动连接和音频采集回退行为恢复固定上游版本。
- 提供中英双语说明、可重复构建工具及最小系统模块模板。

下载下方 **gsm2sip-mtk.apk**，使用 **SHA256SUMS** 校验。
APK 版本 `1.2.0-bakasu-mt6893.2`（427）沿用此前本地测试版的稳定签名，可覆盖升级
本项目的 `1.2.0-bakasu-test.1` 并保留配置。

需要 Android 12+、Root 和已安装的特权模块。当前实验目标为 MT6893/chopin，
不代表支持全部联发科芯片。APK 不会自行安装系统模块或 SIP 服务器。
真实蜂窝双向音频和 SIM 指定呼出尚未验证；iPhone/Asterisk 回声测试只验证 SIP 链路。

适配工具采用 MIT 许可证；APK 根据维护者确认的分发授权提供，不将上游整体重新许可为 MIT。
不包含账号、密码、SIM 号码、设备日志或签名私钥。

## English

- Keeps only the BakaSU global-mount root shell and experimental MT6893 audio profile.
- Restores pinned upstream permission, notification, autoconnect and capture-fallback behavior.
- Includes bilingual documentation, repeatable build tools and a minimal privileged-module template.

Download **gsm2sip-mtk.apk** and verify it with **SHA256SUMS**.
Version `1.2.0-bakasu-mt6893.2` (427) uses the same stable signer as the earlier local
`1.2.0-bakasu-test.1` build and can upgrade it while retaining configuration.

Requires Android 12+, root and an installed privileged module. The experimental target is
MT6893/chopin, not all MediaTek SoCs. The APK does not install a system module or SIP server.
Cellular two-way audio and SIM-specific outgoing calls remain unverified; an iPhone/Asterisk
 echo test only validates the SIP path.

The toolkit is MIT-licensed. The APK is distributed with permission confirmed by the maintainer;
this does not relicense all upstream code under MIT. No credentials, SIM numbers, device logs
or private signing keys are included.

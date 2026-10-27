## BakaSU + MT6893: two runtime adaptations

Downloads: `gsm2sip-mtk-tools-v1.2.0-bakasu-mt6893.2.zip` and `SHA256SUMS`.
The ZIP contains the adaptation tools, module templates and bilingual documentation.

Only `RootShell.kt` and `DeviceProfile.kt` differ at runtime from pinned GSM2SIP.
All earlier notification, permission-request, autoconnect and microphone-fallback
behavior changes have been removed. Build metadata and a minimal local module
template are documented separately.

**Source-only toolkit release.** No upstream source snapshot, APK, populated
module ZIP, account data or signing key is included. Upstream licensing has not
been declared; this release's MIT license applies only to the original tools,
module templates and documentation. See NOTICE.md.

MT6893 cellular two-way audio remains experimental and unverified.

## 仅保留 BakaSU 与 MT6893 两项运行时适配

下载 `gsm2sip-mtk-tools-v1.2.0-bakasu-mt6893.2.zip`，使用 `SHA256SUMS` 核对完整性。
附件包含适配工具、模块模板及中英双语说明。

运行时代码仅修改 `RootShell.kt` 与 `DeviceProfile.kt`。
之前针对通知、权限请求、自动连接和麦克风回退的行为改动均已撤回。
构建元数据和最小模块模板单独说明。

**本次只发布适配工具源码。** 不包含上游源码快照、APK、带 APK 的模块包、账号或签名私钥。
上游尚未声明许可证；MIT 只覆盖本仓库自行编写的工具、模板和说明，详见 NOTICE.md。

MT6893 蜂窝双向通话音频仍为尚未验证的实验适配。

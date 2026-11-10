# GSM2SIP 联发科适配

中文 | [English](README.en.md)

面向 MT6893 的 GSM2SIP 适配工具与模块模板。

[下载安装包](https://github.com/1Fann/gsm2sip-mtk/releases/latest) · [更新说明](https://github.com/1Fann/gsm2sip-mtk/releases)

## 功能

- BakaSU 全局挂载 Root Shell 适配。
- MT6893 实验性通话音频配置。
- 固定上游源码校验、可重复构建和最小特权模块模板。

## 使用

实验目标为 MT6893／chopin、Android 12+ 与 BakaSU／KernelSU，不代表支持全部联发科手机。APK 需配套特权模块；真实蜂窝双向音频和指定 SIM 呼出尚未验证。

从 Releases 下载，按安装说明完成授权，在本机填写自己的账号和连接参数。同包名、同签名的版本可覆盖升级并保留数据。

## 文档

- [构建与安装](docs/BUILD.md)
- [改动范围](docs/CHANGES.md)
- [分发与授权](NOTICE.md)

## 许可证

适配工具采用 MIT；上游 GSM2SIP 的授权单独适用。经维护者确认分发授权的 APK 在 Releases 提供，不能将上游整体视为 MIT 项目，见 [NOTICE.md](NOTICE.md)。

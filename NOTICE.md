# Scope and upstream attribution / 授权范围与上游来源

The MIT license in this repository covers its original adaptation tooling,
module templates and documentation. It does not license GSM2SIP itself.

本仓库的 MIT 许可证覆盖自行编写的适配工具、模块模板和说明文档，
不构成对 GSM2SIP 上游代码的重新授权。

- Upstream / 上游：<https://github.com/OriginStackHQ/GSM2SIP>
- Pinned commit / 固定提交：`0b0a1a68a6e66c8291e053cd70430639df020877`
- Checked on / 核对日期：2026-10-27

At that commit, the upstream tree has no LICENSE, COPYING or NOTICE file;
its README does not declare a software license. The GitHub repository API
also reports no detected license. This repository does not include an upstream
source snapshot, module binaries, screenshots, icons, audio tools or signing keys.
The maintainer has confirmed permission to distribute the signed APK, published
as a Release asset. Verified binary inputs are stored under `releases/` and are
outside the toolkit's MIT license. Source is fetched directly from upstream
into the ignored `.work/` directory when a user chooses to prepare a build.

该提交未包含 LICENSE、COPYING 或 NOTICE 文件，README 也未声明软件许可证；
GitHub 接口未识别到许可证。本仓库不包含上游源码快照、带 APK 的模块包、上游截图、
图标、音频工具或签名密钥。维护者已确认签名 APK 的分发授权，APK 作为 Release
附件提供，经校验的二进制输入保存在 `releases/`，不适用工具的 MIT 许可证。
使用者执行准备命令时，才会直接从上游获取源码到已忽略的 `.work/` 目录。

The toolkit does not grant blanket permission to redistribute upstream code or
all derived binaries. The separately authorized APK does not change upstream's
general license status.

本工具不授予对上游代码或所有衍生二进制的通用分发权；单独获准分发 APK
不改变上游仓库的一般许可状态。

This is an independent adaptation project, not an upstream release or endorsement.

这是独立的适配项目，不是上游官方发布，也不代表上游认可或支持。

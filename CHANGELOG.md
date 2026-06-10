# 更新记录

本项目遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [1.1.0] - 2026-06-10

### 新增

- 新增基础设施运维专家 `expert-ops`，覆盖监控告警、云基础设施与 IaC、安全加固、成本优化、备份恢复和容量规划。
- 新增 `infrastructure-operations-expert` Agent、`expert-ops` Skill 和 Slash Command。
- 总路由器支持通过 `ops` 自动或显式路由到基础设施运维专家。
- 新增安装器回归测试，覆盖本地安装、管道安装、重复安装和无效归档。
- 新增 macOS 与 Linux 双平台 GitHub Actions 安装测试。
- 新增根目录 `VERSION` 文件作为当前版本的唯一来源。

### 变更

- 专家系统扩展为 5 个入口 Skills、18 个 Agents 和 5 个兼容 Commands。
- 安装器在重复安装时先创建唯一备份，再完整替换同名组件，避免旧文件残留。
- 安装器输出实际安装版本。
- 全部 Skills 调整为兼容当前 Codex Skill frontmatter 校验规则。
- README、使用指南、架构文档和安全说明同步更新。

### 修复

- 修复重复安装时目录合并导致旧 Skill 文件继续生效的问题。
- 修复同一秒多次安装可能覆盖已有备份的问题。

## [1.0.0] - 2026-06-09

### 新增

- 首次发布 Codex Expert Teams。
- 提供软件开发、设计原型和产品战略三个专家团。
- 提供 `expert-team` 总路由入口。
- 支持 Codex CLI 与 Codex App 的 Skill 调用方式。
- 支持本地安装、远程一键安装和安装前自动备份。

[1.1.0]: https://github.com/ReJeCtAll/ExpertTeam-Codex/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ReJeCtAll/ExpertTeam-Codex/releases/tag/v1.0.0

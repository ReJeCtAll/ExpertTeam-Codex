# 更新记录

本项目遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

## [1.3.0] - 2026-06-16

### 新增

- 新增 `docs/RELEASE.md` 发布检查清单，明确版本更新、验证、标签和发布后的远程安装复核步骤。
- 安装器回归测试新增仓库元数据一致性检查，覆盖 Skill/Agent/Command 数量、frontmatter 名称匹配、发布文档存在性和版本链接。

### 变更

- 将可选 Slash Command 兼容层中的用户示例统一收敛为 `$expert-*` Skill 调用入口，减少 Codex CLI 和 Codex App 桌面版中的误用。
- README 兼容性说明补充 `.codex/commands/expert-*.md` 仅作为旧环境兼容层。

### 修复

- 修复 command 兼容文档中仍引导用户转交 `/expert-*` 的不一致表述。

## [1.2.0] - 2026-06-13

### 新增

- 新增安全专家 `expert-security`，覆盖威胁建模、漏洞评估、安全代码审查、安全架构、事件响应、安全运营和合规审计。
- 新增 `security-expert` Agent、`expert-security` Skill 和 Slash Command。
- 总路由器支持通过 `security` 自动或显式路由到安全专家。
- 安装器回归测试新增安全专家文件、Skill metadata 和安装日志断言。

### 变更

- 专家系统扩展为 6 个入口 Skills、19 个 Agents 和 6 个兼容 Commands。
- README、使用指南、架构文档和安全说明同步补充安全专家能力、调用方式、协作边界和安装备份路径。

### 修复

- 安装器备份目录移出 `~/.codex/skills` 扫描范围，避免重装备份被 Codex 误识别为旧 Skill。

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

[1.3.0]: https://github.com/ReJeCtAll/ExpertTeam-Codex/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/ReJeCtAll/ExpertTeam-Codex/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/ReJeCtAll/ExpertTeam-Codex/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/ReJeCtAll/ExpertTeam-Codex/releases/tag/v1.0.0

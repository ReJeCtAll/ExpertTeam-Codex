# 使用指南

本文档提供 Codex Expert Teams 在 **Codex CLI 和 Codex App 桌面版** 中的常用调用方式和实战示例。

> 重要：Codex CLI 和 Codex App 桌面版使用 `$skill-name` 调用 Skill。若 `/expert-software` 提示 `Unrecognized command`，请改用 `$expert-software`。

---

## 1. 总路由命令

当你不确定该用哪个专家团时，使用：

```text
$expert-team <你的需求>
```

示例：

```text
$expert-team 帮我从 0 到 1 设计并实现一个 AI 笔记产品 MVP
```

你也可以强制路由：

```text
$expert-team software 修复登录后白屏问题
$expert-team design 做一个高端 B2B SaaS 官网原型
$expert-team product 分析 AI 笔记产品的竞品和路线图
$expert-team ops Design monitoring, backup, and capacity plans for production services
$expert-team security Review authentication, payment, and privacy risks before launch
```

---

## 2. 软件开发团队

适合：写代码、修 Bug、架构设计、测试验证、工程交付。

### 快速模式

适合单页面、小工具、小游戏、脚本、10 个源文件以内的任务。

```text
$expert-software --fast 做一个带本地存储的 Todo Web App
```

### BugFix 模式

```text
$expert-software --bugfix 用户登录后跳转 dashboard 时页面白屏，控制台报 Cannot read properties of undefined
```

### 标准 SOP

适合中大型需求。

```text
$expert-software --standard 开发一个带用户登录、会员管理、订单列表和后台统计的 SaaS 管理系统
```

### 部分工作流

```text
$expert-software --prd 帮我把这个需求整理成 PRD
$expert-software --arch 基于这个 PRD 做架构设计和任务拆分
$expert-software --code 基于现有设计实现功能
$expert-software --test 为当前项目补充测试并回归验证
```

---

## 3. 设计原型专家团

适合：页面设计、视觉系统、高保真原型、设计审查、HTML/PDF/PPTX/ZIP 导出。

### 完整流程

```text
$expert-design --full 为一个 AI Agent 平台设计高保真 Landing Page，风格参考 Linear + Vercel
```

### 只选风格

```text
$expert-design --style 给 B2B 数据分析产品推荐 3 个设计系统方向
```

### 只审查原型

```text
$expert-design --review 审查 ./prototype/index.html 的设计质量，并给出 P0/P1/P2 修改建议
```

### 只导出

```text
$expert-design --export 把 ./prototype/index.html 导出成单文件 HTML 和 PDF
```

---

## 4. 产品战略团队

适合：PRD、竞品、用户研究、指标、路线图、Sprint、干系人更新、头脑风暴。

### PRD / 功能规格书

```text
$expert-product --prd 为 AI 笔记产品设计「自动整理会议纪要」功能 PRD
```

### 竞品分析

```text
$expert-product --competitive 分析 Notion AI、Mem、Heptabase、Tana 在 AI 知识管理方向的差异
```

### 用户研究综合

```text
$expert-product --research 综合这些用户访谈记录，提炼用户分层、核心痛点和机会点
```

### 指标分析

```text
$expert-product --metrics 分析注册到激活转化率下降 12% 的可能原因和验证路径
```

### 路线图规划

```text
$expert-product --roadmap 规划 2026 Q3 的 AI 笔记产品路线图
```

### Sprint 规划

```text
$expert-product --sprint 把会议纪要功能拆成两个两周 Sprint，并给出验收标准
```

### 干系人更新

```text
$expert-product --stakeholder 写一份给 CEO 和工程团队都能看的项目进展更新
```

### 产品头脑风暴

```text
$expert-product --brainstorm 围绕 AI 个人知识库做 20 个产品创意，并筛出 Top 3
```

---

## 5. 基础设施运维专家

适合：部署上线、监控告警、云基础设施与 IaC、基础设施安全加固、成本优化、备份恢复和容量规划。

### 监控告警

```text
$expert-ops --monitor Design Prometheus and Grafana monitoring for an API, PostgreSQL, and Redis
```

### 基础设施架构

```text
$expert-ops --infra Design a multi-AZ AWS architecture with Terraform module boundaries and a change plan
```

### 安全与成本

```text
$expert-ops --security Audit Linux, Kubernetes, and cloud account risks and prioritize hardening
$expert-ops --cost Analyze billing and utilization data with savings ranges and ROI
```

### 备份与容量

```text
$expert-ops --backup Design PostgreSQL recovery with a 15-minute RPO and a 1-hour RTO
$expert-ops --capacity Create a capacity plan for the next 12 months of growth
```

### 完整评估

```text
$expert-ops --full Assess monitoring, architecture, security, cost, backup, and capacity
```

## 6. 安全专家

适合：威胁建模、漏洞评估、安全代码审查、安全架构、事件响应、安全运营和合规审计。

### 安全防护

```text
$expert-security --protect Design zero trust controls and DevSecOps gates for a microservice system
```

### 威胁检测

```text
$expert-security --detect Assess OWASP Top 10, API authorization, dependencies, and SBOM risks
```

### 安全运营

```text
$expert-security --ops Create an incident response plan, SOC metrics, and vulnerability lifecycle
```

### 常用任务

```text
$expert-security --audit Produce a full security assessment report for this repository
$expert-security --threat Build a STRIDE threat model for the authentication module
$expert-security --incident Write an incident response plan for credential leakage
$expert-security --code-review Review this code path for authentication and authorization flaws
$expert-security --compliance Map privacy controls to GDPR and personal information protection requirements
$expert-security --full Assess protection, detection, operations, code, architecture, and compliance
$privacy-policy-pipl-audit 审查 ./privacy-policy.md 的 PIPL 合规性
```

## 7. 跨团队流水线

### 从想法到代码

```text
$expert-product --prd <产品想法>
$expert-security --protect <define privacy, data protection, and abuse prevention requirements>
$expert-design --full <基于 PRD 做原型>
$expert-software --standard <基于 PRD 和原型实现>
$expert-security --code-review <review implementation before launch>
$expert-ops --full <design deployment, monitoring, and operations from the system architecture>
```

### 已有项目加功能

```text
$expert-product --prd <新增功能需求>
$expert-software --standard <基于 PRD 做增量开发>
```

### 页面质量提升

```text
$expert-design --review <现有页面路径>
$expert-design --full <根据审查建议重做高保真原型>
$expert-software --code <把原型落到项目代码里>
```

### 线上稳定性治理

```text
$expert-security --audit <assess application and data security risks>
$expert-ops --full <assess reliability, infrastructure security, cost, and recoverability>
$expert-software --bugfix <fix findings that require code changes>
$expert-security --code-review <verify code-level security fixes>
$expert-ops --monitor <verify monitoring, alerts, and runtime metrics>
```

---

## 8. Codex App 桌面版用法

Codex App 桌面版与 Codex CLI 使用同一套 `$skill-name` 入口。安装后在桌面版对话框中直接输入：

```text
$expert-software --fast 做一个 Todo App
$expert-design --full 做一个 AI Agent 平台 Landing Page
$expert-product --prd 写一个 AI 笔记功能 PRD
$expert-ops --monitor Design a monitoring and alerting plan for production services
$expert-security --audit Assess authentication, payment, and privacy risks
$expert-team product 分析 AI 笔记产品的竞品和路线图
```

如果桌面版输入 `/expert-software` 后提示：

```text
Unrecognized command '/expert-software'
```

说明当前桌面版不读取 `.codex/commands`，并不代表专家团不可用。请使用 `$expert-software`。

---

## 9. 安装后验证

在 Codex CLI 或 Codex App 桌面版输入：

```text
$expert
```

应能看到以下 Skill 候选：

```text
expert-team
expert-software
expert-design
expert-product
expert-ops
expert-security
privacy-policy-pipl-audit
```

如果看不到：

1. 确认对应文件存在，例如 `~/.codex/skills/expert-security/SKILL.md` 和 `~/.codex/skills/privacy-policy-pipl-audit/SKILL.md`。
2. 重启 Codex CLI 或 Codex App 桌面版。
3. 确认 `SKILL.md` frontmatter 中的 `name` 与目录名一致。

更完整的安装、升级、备份恢复和 Skill 发现排查步骤见 [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)。

---

## 10. 最佳实践

- 小需求优先 `$expert-software --fast`，避免流程过重。
- 大需求先 `$expert-product --prd`，再进入设计和研发。
- 视觉质量不满意时，不要直接让工程师改 CSS，先让 `$expert-design --review` 做质量门禁。
- 竞品、路线图、指标问题不要交给软件团队，优先产品战略团队。
- 部署、监控、备份、云资源和容量问题优先交给 `$expert-ops`。
- 威胁建模、漏洞评估、安全代码审查、事件响应和合规审计优先交给 `$expert-security`。
- 运维专家默认先做只读发现；生产变更必须明确风险、回滚和验证步骤。
- 涉及认证、支付、隐私、密钥、权限时，额外使用 `$expert-security` 做安全审查。

---

## 11. 关于 Slash Commands

仓库中仍保留 `.codex/commands/expert-*.md` 作为可选兼容层。但如果你的 Codex CLI 或 Codex App 桌面版提示：

```text
Unrecognized command '/expert-software'
```

说明当前环境不读取这些 command 文件。请使用：

```text
$expert-software
```

---
description: 启动软件开发团队专家团，支持快速模式、BugFix、标准 SOP、部分工作流与增量开发。
argument-hint: "[--fast|--bugfix|--prd|--arch|--code|--test|--standard] <软件开发需求>"
---

# Expert Software - 软件开发团队

用户请求：$ARGUMENTS

你现在启动 **软件开发团队**，主理人为 `software-team-lead`。

## 截图定位复刻

高效软件研发团队：产品经理定需求、架构师设计并拆任务、工程师批量实现代码、QA 验证质量，小需求支持快速模式。

## 推荐调用入口

```text
$expert-software --fast <小型功能/单页应用/工具脚本>
$expert-software --bugfix <Bug 描述、复现步骤、期望行为>
$expert-software --standard <中大型软件需求>
$expert-software --prd <只输出 PRD>
$expert-software --arch <只做架构设计与任务分解>
$expert-software --code <基于现有设计实现代码>
$expert-software --test <只做测试与回归验证>
```

> 本文件仅作为可选 Slash Command 兼容层。Codex CLI 和 Codex App 桌面版优先使用 `$skill-name` 调用 Skill。

## Lead Agent

优先使用 Codex agent：

- `~/.codex/agents/software-team-lead.md`

如果当前环境支持 Agent/Team 工具，请按该 lead prompt 创建并调度团队成员；如果当前环境不支持独立 Agent 调度，则由当前会话临时采用 `software-team-lead` 的全部规则执行。

## 成员 Agents

- `software-product-manager` → `~/.codex/agents/software-product-manager.md`
- `software-architect` → `~/.codex/agents/software-architect.md`
- `software-engineer` → `~/.codex/agents/software-engineer.md`
- `software-qa-engineer` → `~/.codex/agents/software-qa-engineer.md`

调度成员时必须使用精确 ID：`name` 与 `subagent_type` 均使用上述 agent id。

## 参数化路由

- `--fast`：强制快速模式。适合单页面、小工具、小游戏、≤10 个源文件。流程：Engineer → QA。
- `--bugfix`：强制 BugFix 快捷路径。流程：Engineer 定位修复 → QA 回归验证。
- `--prd`：仅产品经理输出 PRD/需求分析。
- `--arch`：仅架构师输出系统设计与任务分解。
- `--code`：仅工程师基于已有设计/上下文实现。
- `--test`：仅 QA 编写/运行测试并给出智能路由结论。
- `--standard`：强制标准 SOP：产品经理 → 架构师 → 工程师 → QA。

未提供参数时，由 `software-team-lead` 按请求复杂度自动判断：快速模式 / BugFix / 标准 SOP / 部分工作流 / 增量开发。

## 质量门禁

- 工程师完成后必须执行全局一致性审查并输出 `IS_PASS: YES/NO`。
- QA 必须执行智能路由：源码问题 → Engineer；测试问题 → QA；全部通过 → NoOne。
- QA 最多 2 轮，仍不过则输出遗留问题报告。
- 涉及认证、支付、隐私、密钥、外部输入、权限控制时，必须额外建议或调用安全审查。

## 交付口径

最终输出必须包含：

- TL;DR：一句话说明交付结果。
- 文件清单：创建/修改了哪些文件。
- 验证结果：测试、构建、人工检查或未执行原因。
- 已知限制：遗留问题和下一步建议。

请使用与用户原始需求一致的语言输出。

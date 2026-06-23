# 领域术语表

## Expert Team

面向一类用户任务的专家入口。它通过结构化工作流分派、串联和收口任务，可以协调多个 Agents 和 Supporting Skills。

## Entrypoint Skill

用户直接通过 `$expert-*` 调用的 Codex Skill。Entrypoint Skill 定义团队或单专家的路由规则、边界和输出要求。

## Supporting Skill

通常不由用户直接调用的 Codex Skill。Supporting Skill 为 Entrypoint Skills 和 Agents 提供知识库、模板、评分规则或方法手册。

## Agent

安装在 `.codex/agents` 下的角色提示词。Agent 表示具体专家职责，例如产品分析、架构、工程、QA、设计审查、运维或安全。

## Team Lead Agent

负责多 Agent 工作流编排的 Agent。Team Lead Agent 分派任务、传递上下文并汇总成员产出。

## Single Expert

由一个专业 Agent 支撑的 Entrypoint Skill，而不是完整团队。Single Expert 用于职责清晰、额外角色会制造虚假协作成本的场景。

## Slash Commands Compatibility Layer

保留在 `.codex/commands/expert-*.md` 的可选兼容配置，用于仍读取 slash command 的旧环境。它不是当前推荐主入口。

## Release Gate

版本发布前必须通过的检查集合，包括 shell 语法、安装回归测试、版本元数据一致性、仓库元数据一致性和发布文档审查。

## Install Preview

安装器的非写入模式。Install Preview 展示将安装或备份的组件，但不会创建目录、复制文件或替换已有内容。

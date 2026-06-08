# 专家团架构说明

Codex Expert Teams 由 4 个 Codex CLI / Codex App 桌面版入口 Skills、17 个 Agents、4 个支撑 Skills，以及 4 个可选 Slash Commands 兼容层组成。

---

## 总览

```text
$expert-team
├── $expert-software
│   ├── software-team-lead
│   ├── software-product-manager
│   ├── software-architect
│   ├── software-engineer
│   └── software-qa-engineer
├── $expert-design
│   ├── design-engine-team-lead
│   ├── discovery-analyst
│   ├── design-system-expert
│   ├── prototype-builder
│   ├── critique-reviewer
│   └── export-specialist
└── $expert-product
    ├── product-director
    ├── requirement-analyst
    ├── user-researcher
    ├── competitive-analyst
    ├── data-analyst
    └── roadmap-planner
```

---

## 1. 软件开发团队

### 定位

高效软件研发团队：产品经理定需求、架构师设计并拆任务、工程师批量实现代码、QA 验证质量，小需求支持快速模式。

### 成员

| Agent | 角色 | 职责 |
|---|---|---|
| `software-team-lead` | 主理人 / 交付总监 | 判断工作流，编排成员，汇总交付 |
| `software-product-manager` | 产品经理 | PRD、需求分析、市场/竞品研究 |
| `software-architect` | 架构师 | 系统设计、任务拆解、依赖规划 |
| `software-engineer` | 工程师 | 批量编码、全局一致性审查 |
| `software-qa-engineer` | QA 工程师 | 编写测试、回归验证、智能路由 |

### 工作流

- 快速模式：Engineer → QA
- BugFix：Engineer 定位修复 → QA 回归
- 标准 SOP：PM → Architect → Engineer → QA
- 部分工作流：只 PRD / 只架构 / 只代码 / 只测试

### 质量门禁

- Engineer 输出 `IS_PASS: YES/NO`
- QA 最多 2 轮测试
- 测试失败时明确路由到 Engineer / QA / Known Issues

---

## 2. 设计原型专家团

### 定位

覆盖从需求发现到品牌级原型交付的完整工作流，内置 71 套设计系统，产出高保真、可运行、可导出的原型。

### 成员

| Agent | 角色 | 职责 |
|---|---|---|
| `design-engine-team-lead` | 主理人 | 编排设计流程与交付 |
| `discovery-analyst` | 需求发现分析师 | 明确场景、受众、调性、约束 |
| `design-system-expert` | 设计系统专家 | 推荐设计系统、生成设计令牌 |
| `prototype-builder` | 原型构建师 | 生成 HTML/CSS 高保真原型 |
| `critique-reviewer` | 质量审查官 | 5 维评分、Anti-Slop 检查 |
| `export-specialist` | 导出交付专家 | 导出 HTML/PDF/PPTX/ZIP |

### Skills

| Skill | 用途 |
|---|---|
| `design-systems` | 71 套设计系统知识库 |
| `prototype-templates` | 原型模板结构 |
| `quality-review` | 质量评分与 Anti-Slop 检查 |

### 质量门禁

- 必须使用明确设计系统和设计令牌
- 禁止套路化 AI 视觉
- 5 维评分任一维度低于 3/5 必须回修

---

## 3. 产品战略团队

### 定位

由产品总监领导的 5 人产品专家团队，面向产品战略、竞品分析和路线图规划。

### 成员

| Agent | 角色 | 职责 |
|---|---|---|
| `product-director` | 主理人 / 产品舵手 | 编排产品管理全流程 |
| `requirement-analyst` | 需求分析师 | PRD、功能规格、范围管理 |
| `user-researcher` | 用户研究员 | 用户调研综合分析、洞察提炼 |
| `competitive-analyst` | 竞品分析师 | 竞品分析、市场定位、Battle Card |
| `data-analyst` | 数据分析师 | 产品指标、漏斗、留存、异常分析 |
| `roadmap-planner` | 路线图规划师 | 路线图、Sprint、干系人沟通 |

### Skill

| Skill | 用途 |
|---|---|
| `product-playbook` | 产品管理完整手册 |

### 工作流

- PRD / 功能规格书
- 竞品分析
- 用户研究综合
- 指标评审
- 路线图规划
- Sprint 规划
- 干系人更新
- 产品头脑风暴

---

## 4. 扩展方式

### 新增团队

1. 在 `.codex/agents/` 添加新的 lead agent。
2. 添加成员 agent。
3. 在 `.codex/commands/` 创建新的 slash command。
4. 更新 `expert-team.md` 的路由表。

### 新增 Skill

1. 在 `.codex/skills/<skill-name>/SKILL.md` 添加 skill 定义。
2. 如有参考资料，放在 `.codex/skills/<skill-name>/references/`。
3. 在相关 agent 或 command 中引用。

### 调整质量门禁

优先修改 lead agent，而不是只修改 command。Command 负责路由，Lead Agent 负责团队执行规则。

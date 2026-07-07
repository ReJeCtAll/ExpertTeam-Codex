# 专家团架构说明

Codex Expert Teams 由 7 个 Codex CLI / Codex App 桌面版入口 Skills、20 个 Agents、5 个支撑 Skills，以及 7 个可选 Slash Commands 兼容层组成。业务入口包括 3 个团队型专家团和 3 个单专家，总路由统一分发。

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
├── $expert-product
│   ├── product-director
│   ├── requirement-analyst
│   ├── user-researcher
│   ├── competitive-analyst
│   ├── data-analyst
│   └── roadmap-planner
├── $expert-ops
│   └── infrastructure-operations-expert
├── $expert-security
│   └── security-expert
└── $expert-database
    └── database-optimization-expert
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

由产品总监领导的 6 人产品专家团队，面向产品战略、竞品分析和路线图规划。

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

## 4. 基础设施运维专家

### 定位

单专家模式，负责部署上线后的可靠性、可观测性、安全、成本、备份和容量问题。它不创建虚假的多角色团队，而是按专项参数直接进入对应运维工作流。

### Agent

| Agent | 角色 | 职责 |
|---|---|---|
| `infrastructure-operations-expert` | 基础设施运维专家 | 事实基线、风险评估、方案设计、变更计划、验证与健康报告 |

### 工作流

- `--monitor`：监控、告警、日志、追踪和 SLO
- `--infra`：云基础设施、网络、IaC 和自动扩缩容
- `--security`：漏洞、权限、密钥、审计、事件响应和合规差距
- `--cost`：资源利用率、规格调整、预留容量和 ROI
- `--backup`：RPO/RTO、备份、加密、异地副本和恢复演练
- `--capacity`：增长预测、资源水位、扩容触发器和投资需求
- `--full`：完整基础设施健康评估

### 质量门禁

- 默认先做只读发现，不在未授权时修改生产环境
- 所有生产变更必须包含预检查、回滚条件、观察窗口和验证指标
- 配置与脚本必须声明版本假设、依赖和待替换变量
- 合规结论必须基于证据，不能仅凭清单宣称通过认证
- 成本与 ROI 必须给出计算口径，缺少数据时标注估算区间

## 5. 安全专家

### 定位

单专家模式，负责威胁建模、漏洞评估、安全代码审查、安全架构、事件响应、安全运营和合规审计。它与 `$expert-ops` 的边界是：安全专家定义风险、控制项、审计结论和验证闭环；运维专家负责基础设施、云资源、监控、WAF、SIEM 等生产环境落地。

### Agent

| Agent | 角色 | 职责 |
|---|---|---|
| `security-expert` | 安全专家 | 威胁建模、漏洞评估、代码审计、安全架构、事件响应、合规差距分析和整改路线图 |

### 工作流

- `--protect`：安全防护，覆盖威胁建模、零信任架构、DevSecOps、数据安全、IAM 和安全基线
- `--detect`：威胁检测，覆盖 OWASP Top 10、API 安全、容器安全、依赖漏洞、SBOM、代码审计、入侵检测、WAF 和 RASP
- `--ops`：安全运营，覆盖事件响应、根因分析、SOC 建设、漏洞管理生命周期和合规治理
- `--audit`：全面安全审计
- `--threat`：STRIDE 威胁建模
- `--incident`：事件响应预案
- `--code-review`：安全代码审查
- `--compliance`：等保、SOC 2、ISO 27001、GDPR、个人信息保护法或 PCI-DSS 合规差距分析
- `--full`：完整安全健康评估

### Skills

| Skill | 用途 |
|---|---|
| `privacy-policy-pipl-audit` | 基于 PIPL 和 GB/T 35273-2020 对隐私政策/隐私协议文案做 18 维合规审查 |

### 质量门禁

- 必须确认评估范围、授权边界和敏感数据处理方式
- 发现必须绑定证据、位置、影响、复现条件、修复建议和验证方式
- 严重等级按 Critical / High / Medium / Low / Info 标准化输出
- 合规结论只能说明控制项覆盖、证据质量和差距，不能仅凭清单宣称通过认证
- 未经授权不探测第三方系统，不绕过访问控制，不执行破坏性攻击

## 6. 数据库优化专家

### 定位

单专家模式，负责 Schema 设计、SQL 查询优化、索引策略、执行计划分析、连接池、慢查询治理和安全迁移。它与 `$expert-software` 的边界是：数据库专家定义数据模型、SQL、索引和迁移方案；软件开发团队负责业务代码、ORM 查询、测试和工程实现。

### Agent

| Agent | 角色 | 职责 |
|---|---|---|
| `database-optimization-expert` | 数据库优化专家 | 事实基线、执行计划分析、Schema/索引设计、安全迁移、连接池治理和性能验证 |

### 工作流

- `--schema`：Schema 设计、约束、范式化与反范式化取舍
- `--query`：SQL 查询优化、执行计划解读、慢查询和 N+1 查询治理
- `--index`：B-tree、GIN、GiST、BRIN、部分索引、表达式索引、复合索引和写入成本评估
- `--migration`：可逆迁移、零停机 DDL、分批回填、双写、锁风险和回滚方案
- `--pooling`：PgBouncer、Supabase Pooler、serverless 连接治理和连接数上限
- `--review`：审查已有 Schema、SQL、ORM 查询、索引或迁移脚本
- `--full`：完整数据库健康评估

### 质量门禁

- 默认先做只读分析，不在未授权时修改生产数据库
- 关键 SQL 和索引建议必须包含执行计划或可验证指标
- 生产 DDL、索引创建和批量回填必须说明锁风险、回滚路径和观察窗口
- 示例 SQL 必须标注数据库类型、版本假设和待替换变量
- 涉及真实连接串、密码、Token、客户数据或个人敏感信息时必须脱敏

## 7. 跨专家协作边界

```text
$expert-product
      ↓
$expert-security
      ↓
$expert-design
      ↓
$expert-software
      ↓
$expert-database
      ↓
$expert-security
      ↓
$expert-ops
```

- 产品战略团队负责产品决策、需求分析和投资优先级。
- 安全专家在产品阶段提供隐私、安全和合规输入，在上线前执行威胁建模、代码审计和安全评估。
- 设计原型专家团负责视觉设计、交互和原型。
- 软件开发团队负责代码、测试和工程实现。
- 数据库优化专家负责 Schema、SQL、索引、连接池、迁移安全和数据库性能验证。
- 基础设施运维专家负责部署、监控、基础设施安全加固、成本、备份和容量。
- 运维专家发现需要开发自动化工具或平台功能时，转交 `$expert-software`。
- 运维专家遇到容量投资和预算优先级决策时，转交 `$expert-product`。
- 安全专家发现需要代码修复时，转交 `$expert-software`；发现需要云资源、WAF、SIEM 或生产变更落地时，转交 `$expert-ops`。
- 数据库专家发现需要改业务代码或 ORM 查询时，转交 `$expert-software`；需要数据库实例、备份、云监控或连接代理落地时，转交 `$expert-ops`；涉及 SQL 注入、敏感数据或审计合规时，转交 `$expert-security`。

## 8. 扩展方式

### 新增团队

1. 在 `.codex/agents/` 添加新的 lead agent 或单专家 agent。
2. 团队型入口添加成员 agent；单专家入口无需虚构成员。
3. 在 `.codex/skills/` 添加正式 Skill 入口。
4. 在 `.codex/commands/` 创建可选 slash command。
5. 更新 `expert-team` Skill 和 command 的路由表。

### 新增 Skill

1. 在 `.codex/skills/<skill-name>/SKILL.md` 添加 skill 定义。
2. 如有参考资料，放在 `.codex/skills/<skill-name>/references/`。
3. 在相关 agent 或 command 中引用。

### 调整质量门禁

团队型入口优先修改 lead agent，单专家入口优先修改对应 agent。Command 负责兼容路由，Agent 负责专业执行规则。

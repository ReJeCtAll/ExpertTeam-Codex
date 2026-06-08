# Codex Expert Teams

一套可直接安装到 `~/.codex` 的专家团配置，面向 **Codex CLI / Codex App 桌面版的 Skill 调用方式** 提供 3 个专家团与 1 个总路由入口。

> 重要：Codex CLI 和 Codex App 桌面版当前主要通过 `$skill-name` 调用 Skill，例如 `$design`。因此本仓库的推荐调用方式是 `$expert-software`、`$expert-design`、`$expert-product`、`$expert-team`。

---

## 核心能力

- **软件开发团队**：PRD、架构设计、批量编码、QA 验证、BugFix。
- **设计原型专家团**：需求发现、设计系统选择、高保真原型、质量审查、导出交付。
- **产品战略团队**：PRD、用户研究、竞品分析、指标分析、路线图、Sprint、干系人沟通。
- **专家团总路由器**：根据任务自动选择合适团队，或手动指定团队。

适用场景：想把 Codex 从「单个助手」升级为「可路由、可协作、可复用的专家团系统」。

---

## 目录结构

```text
.
├── .codex/
│   ├── skills/
│   │   ├── expert-team/              # Codex CLI/App 入口：$expert-team
│   │   ├── expert-software/          # Codex CLI/App 入口：$expert-software
│   │   ├── expert-design/            # Codex CLI/App 入口：$expert-design
│   │   ├── expert-product/           # Codex CLI/App 入口：$expert-product
│   │   ├── design-systems/           # 设计系统知识库
│   │   ├── prototype-templates/      # 原型模板
│   │   ├── quality-review/           # 质量审查规则
│   │   └── product-playbook/         # 产品管理手册
│   ├── agents/
│   │   ├── software-team-lead.md
│   │   ├── software-product-manager.md
│   │   ├── software-architect.md
│   │   ├── software-engineer.md
│   │   ├── software-qa-engineer.md
│   │   ├── design-engine-team-lead.md
│   │   ├── discovery-analyst.md
│   │   ├── design-system-expert.md
│   │   ├── prototype-builder.md
│   │   ├── critique-reviewer.md
│   │   ├── export-specialist.md
│   │   ├── product-director.md
│   │   ├── requirement-analyst.md
│   │   ├── user-researcher.md
│   │   ├── competitive-analyst.md
│   │   ├── data-analyst.md
│   │   └── roadmap-planner.md
│   └── commands/                     # 可选兼容配置
│       ├── expert-team.md
│       ├── expert-software.md
│       ├── expert-design.md
│       └── expert-product.md
├── docs/
│   ├── USAGE.md
│   └── TEAM_ARCHITECTURE.md
├── install.sh
├── LICENSE
├── SECURITY.md
└── README.md
```

---

## 快速安装

### 方式 1：一键安装

```bash
chmod +x install.sh
./install.sh
```

安装脚本会：

1. 创建 `~/.codex/skills`、`~/.codex/agents`、`~/.codex/commands`。
2. 将本仓库的专家团配置复制进去。
3. 对同名旧文件自动备份为 `.bak.<timestamp>`，避免直接覆盖丢失。

### 方式 2：手动复制

```bash
mkdir -p ~/.codex/skills ~/.codex/agents ~/.codex/commands
cp -R .codex/skills/* ~/.codex/skills/
cp -R .codex/agents/* ~/.codex/agents/
cp -R .codex/commands/* ~/.codex/commands/
```

---

## Codex CLI / Codex App 桌面版可用命令

### 总路由

```text
$expert-team <你的需求>
$expert-team software <软件开发需求>
$expert-team design <设计原型需求>
$expert-team product <产品战略需求>
```

### 软件开发团队

```text
$expert-software --fast <小型功能/单页应用/工具脚本>
$expert-software --bugfix <Bug 描述、复现步骤、期望行为>
$expert-software --standard <中大型软件需求>
$expert-software --prd <只输出 PRD>
$expert-software --arch <只做架构设计与任务分解>
$expert-software --code <基于现有设计实现代码>
$expert-software --test <只做测试与回归验证>
```

### 设计原型专家团

```text
$expert-design --full <从需求发现到原型导出完整流程>
$expert-design --style <只推荐设计系统/视觉风格/设计令牌>
$expert-design --review <审查现有原型或页面质量>
$expert-design --export <导出已有原型为 HTML/PDF/PPTX/ZIP>
```

### 产品战略团队

```text
$expert-product --prd <功能规格书/PRD/需求分析>
$expert-product --competitive <竞品分析/市场定位/Battle Card>
$expert-product --research <用户访谈/问卷/NPS/反馈综合>
$expert-product --metrics <产品指标/漏斗/留存/异常分析>
$expert-product --roadmap <路线图/季度规划/优先级排序>
$expert-product --sprint <Sprint 规划/故事拆分/容量评估>
$expert-product --stakeholder <周报/月报/项目进展/高管更新>
$expert-product --brainstorm <产品创意发散与收敛>
```

---

## 安装后验证

在 Codex CLI 或 Codex App 桌面版输入：

```text
$expert
```

如果能看到类似以下 Skill，说明安装成功：

```text
expert-team
expert-software
expert-design
expert-product
```

然后测试：

```text
$expert-software --fast 做一个 Todo App
```

---

## Codex App 桌面版说明

Codex App 桌面版与 Codex CLI 保持同样用法：

```text
$expert-software --fast 做一个 Todo App
$expert-design --full 做一个 AI Agent 平台 Landing Page
$expert-product --prd 写一个 AI 笔记功能 PRD
$expert-team product 分析 AI 笔记产品的竞品和路线图
```

验证方式同样是输入：

```text
$expert
```

若能看到 `expert-team`、`expert-software`、`expert-design`、`expert-product`，说明桌面版已识别这些专家团 Skills。

---

## 推荐流水线

从 0 到 1 做产品：

```text
$expert-product --prd <产品想法>
$expert-design --full <基于 PRD 做高保真原型>
$expert-software --standard <基于 PRD 和原型实现工程代码>
```

小型功能或工具：

```text
$expert-software --fast <需求>
```

只做视觉原型：

```text
$expert-design --full <页面或产品原型需求>
```

## 设计原则

- **专家团路由**：让任务先进入正确团队，而不是一个助手包办所有事情。
- **主理人编排**：每个团队都有 Lead Agent，负责拆分、转交、汇总和收口。
- **质量门禁**：软件团队有工程一致性与 QA 路由；设计团队有 5 维评分与 Anti-Slop 检查；产品团队有结构化报告与行动清单。
- **可复用配置**：Skills、Agents、Commands 分离，方便单独替换或扩展。
- **安全默认值**：安装脚本备份同名文件；仓库不包含密钥、Token 或个人绝对路径。

---

## 兼容性说明

| 环境能力 | 推荐入口 | 效果 |
|---|---|---|
| Codex CLI 支持 Skills | `$expert-*` | 推荐，当前主入口 |
| Codex App 桌面版支持 Skills | `$expert-*` | 与 CLI 同样用法 |
| 环境支持 Agents | `$expert-*` + agents | 更接近多角色专家团 |
| 只支持普通对话 | 复制 Skill 内容 | 可作为结构化 Prompt 使用 |

---

## 开源协议

MIT License。详见 [LICENSE](LICENSE)。

---

## 贡献建议

欢迎提交：

- 新专家团模板
- 更细的 Agent 角色
- 更严格的质量门禁
- 更好的跨团队流水线
- 不同技术栈或行业场景的 Skills

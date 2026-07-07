# Release Checklist

本文档用于发布 Codex Expert Teams 新版本。发布前必须保证工作区干净、版本元数据一致，并完成安装回归测试。

## 1. 确认发布范围

- 确认本次版本类型：major、minor 或 patch。
- 确认 `main` 已包含本次发布所需的全部变更。
- 确认没有未纳入发布说明的用户可见行为变化。

## 2. 更新版本元数据

1. 更新 `VERSION`，内容只保留裸 SemVer，例如 `<new-version>`。
2. 更新 `README.md` 中的当前版本和版本示例。
3. 在 `CHANGELOG.md` 顶部新增对应版本段落。
4. 在 `CHANGELOG.md` 底部新增 compare link，例如：

```markdown
[<new-version>]: https://github.com/ReJeCtAll/ExpertTeam-Codex/compare/v<previous-version>...v<new-version>
```

## 3. 本地验证

运行以下命令：

```bash
bash -n install.sh
bash -n tests/install_test.sh
tests/install_test.sh
```

验证点：

- `VERSION` 是合法 SemVer。
- README 当前版本与 `VERSION` 一致。
- `CHANGELOG.md` 存在当前版本段落和 compare link。
- `.codex/skills/*/SKILL.md` 的 `name` 与目录名一致。
- `.codex/agents/*.md` 的 `name` 与文件名一致。
- README 和使用指南链接到 `docs/TROUBLESHOOTING.md`。
- 安装器组件清单、安装预览、本地安装、管道安装、跳过可选 Commands、重复安装备份和无效归档拒绝测试均通过。

## 4. 创建标签

确认本地验证通过后创建标签：

```bash
git tag -a v<new-version> -m "Release v<new-version>"
git push origin main
git push origin v<new-version>
```

## 5. 发布后验证

发布后在临时目录或自定义 `CODEX_HOME` 中复核远程安装：

```bash
curl -fsSL https://raw.githubusercontent.com/ReJeCtAll/ExpertTeam-Codex/main/install.sh \
  | CODEX_HOME=/tmp/expert-team-codex-release-check bash
```

确认输出版本与 `VERSION` 一致，并确认以下 Skills 可见：

```text
expert-team
expert-software
expert-design
expert-product
expert-ops
expert-security
expert-database
privacy-policy-pipl-audit
```

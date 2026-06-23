# Troubleshooting

本文档用于排查 Codex Expert Teams 安装、升级和 Skill 发现问题。默认安装目标是 `~/.codex`，如果你设置了 `CODEX_HOME`，请把下方路径替换为对应目录。

## 1. 安装前先预览

如果不确定安装会覆盖哪些本地配置，先运行：

```bash
./install.sh --dry-run
```

只查看仓库包含哪些组件：

```bash
./install.sh --list
```

如果你的环境只需要 Skills 和 Agents，不需要旧版 Slash Commands 兼容层：

```bash
./install.sh --no-commands
```

远程安装同样支持这些参数：

```bash
curl -fsSL https://raw.githubusercontent.com/ReJeCtAll/ExpertTeam-Codex/main/install.sh | bash -s -- --dry-run
```

## 2. 安装后看不到 `$expert-*`

先确认文件是否安装到 Codex 实际读取的目录：

```bash
ls ~/.codex/skills/expert-team/SKILL.md
ls ~/.codex/skills/expert-software/SKILL.md
ls ~/.codex/skills/expert-design/SKILL.md
ls ~/.codex/skills/expert-product/SKILL.md
ls ~/.codex/skills/expert-ops/SKILL.md
ls ~/.codex/skills/expert-security/SKILL.md
```

然后在 Codex CLI 或 Codex App 桌面版输入：

```text
$expert
```

如果仍然看不到候选项：

1. 重启 Codex CLI 或 Codex App 桌面版。
2. 确认你没有把 `CODEX_HOME` 指向另一个目录。
3. 检查 `SKILL.md` frontmatter 中的 `name` 是否与目录名一致。
4. 确认备份目录没有放在 `~/.codex/skills` 下面。

## 3. `/expert-*` 提示无法识别

当前推荐入口是 `$expert-*` Skill 调用方式，而不是 `/expert-*`。

如果看到：

```text
Unrecognized command '/expert-software'
```

请改用：

```text
$expert-software
```

`.codex/commands/expert-*.md` 只是可选 Slash Commands 兼容层。使用 `--no-commands` 安装时不会复制这些文件，不影响 `$expert-*` Skills。

## 4. 升级后出现旧内容

安装器会先备份同名组件，再完整替换目标目录。备份位于：

```text
~/.codex/backups/expert-team/<timestamp>/
~/.codex/backups/expert-team/<timestamp>.<sequence>/
```

如果升级后仍看到旧内容，常见原因是当前会话还没有刷新 Skill 缓存。请重启 Codex CLI 或 Codex App 桌面版后再试。

## 5. 恢复本地修改

如果安装覆盖了你本地改过的同名组件，可以从备份目录恢复。例如：

```bash
cp -R ~/.codex/backups/expert-team/<timestamp>/skills/expert-team ~/.codex/skills/expert-team
```

恢复前建议先查看备份内容：

```bash
find ~/.codex/backups/expert-team -maxdepth 3 -type f | sort
```

## 6. 远程安装失败

远程安装依赖 `bash`、`curl`、`tar` 和网络访问 GitHub。先检查这些命令：

```bash
command -v bash
command -v curl
command -v tar
```

如果下载失败，可以克隆仓库后本地安装：

```bash
git clone https://github.com/ReJeCtAll/ExpertTeam-Codex.git
cd ExpertTeam-Codex
./install.sh --dry-run
./install.sh
```

## 7. 发布前自检

维护者发布前应运行：

```bash
bash -n install.sh
bash -n tests/install_test.sh
tests/install_test.sh
```

这些检查会覆盖版本元数据、仓库结构、安装预览、本地安装、管道安装、跳过 commands、重复安装备份替换和无效归档拒绝。

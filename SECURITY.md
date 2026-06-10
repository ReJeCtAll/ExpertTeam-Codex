# Security Policy

## 安全原则

本仓库只包含 Codex commands、agents、skills 的 Markdown 配置，不应包含：

- API Key
- Token
- 私有仓库地址
- 个人账号信息
- 服务器 IP、内网地址或凭证
- Webhook URL
- 生产环境配置

## 安装安全

`install.sh` 会在替换同名文件或目录前创建备份：

```text
<filename>.bak.<timestamp>
<filename>.bak.<timestamp>.<sequence>
```

当同一秒内发生多次安装时，脚本使用递增序号保留每次备份。备份成功后，同名组件会被完整替换，而不是与旧目录合并，以避免已删除的旧配置继续生效。

建议安装前先检查本地 `~/.codex` 中已有配置，确认没有重要自定义内容会被覆盖。

## 使用安全

当专家团被用于以下场景时，建议额外做安全审查：

- 身份认证 / 登录注册
- 支付 / 订单 / 钱包
- 用户隐私数据
- 密钥、Token、凭证管理
- 权限控制
- 文件上传
- 外部输入处理
- 数据库迁移
- 线上部署

## 报告问题

如果发现配置中存在敏感信息、危险指令或不安全默认值，请提交 Issue 或 Pull Request。

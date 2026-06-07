> [English](../../reference/authentication.md) · **[中文](.)**

# 认证

Specify CLI 对目录源的 HTTP 请求、扩展下载和版本检查使用**选择加入的认证**机制。除非你显式配置，否则不会发送任何凭据。

## 配置

创建 `~/.specify/auth.json` 以启用认证：

```json
{
  "providers": [
    {
      "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    }
  ]
}
```

> **安全提示：** 将文件权限限制为仅拥有者可访问：
> ```bash
> chmod 600 ~/.specify/auth.json
> ```

没有此文件时，所有 HTTP 请求均为未认证状态。

## 字段

`providers` 数组中的每个条目包含以下字段：

| 字段 | 必填 | 说明 |
| --- | --- | --- |
| `hosts` | 是 | 此条目适用的主机名数组。支持精确主机名，或用于子域名匹配的前导 `*.` 通配符（例如 `*.visualstudio.com`）。`*.visualstudio.com` 匹配 `foo.visualstudio.com`，但不匹配 `visualstudio.com`。不支持 `*github.com` 或 `gith?b.com` 等其他通配符模式。 |
| `provider` | 是 | 内置提供者键值：`github` 或 `azure-devops`。 |
| `auth` | 是 | 认证方案（见下文）。 |
| `token` | 否 | 令牌值（内联）。尽可能使用 `token_env`。 |
| `token_env` | 否 | 从中读取令牌的环境变量名称。 |

对于 `azure-ad` 认证，需要额外字段：

| 字段 | 必填 | 说明 |
| --- | --- | --- |
| `tenant_id` | 是 | Azure AD 租户 ID。 |
| `client_id` | 是 | 服务主体客户端 ID。 |
| `client_secret_env` | 是 | 包含客户端密钥的环境变量。 |

对于 `bearer` 和 `basic-pat` 方案，必须设置 `token` 或 `token_env`。

## 提供者与认证方案

### GitHub（`github`）

| 方案 | 请求头 | 用途 |
| --- | --- | --- |
| `bearer` | `Authorization: Bearer <token>` | PAT、细粒度 PAT、OAuth 令牌、GitHub App 令牌 |

**示例 — 通过环境变量使用 PAT：**

```json
{
  "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
  "provider": "github",
  "auth": "bearer",
  "token_env": "GH_TOKEN"
}
```

### Azure DevOps（`azure-devops`）

| 方案 | 请求头 | 用途 |
| --- | --- | --- |
| `basic-pat` | `Authorization: Basic base64(:<PAT>)` | 个人访问令牌 |
| `bearer` | `Authorization: Bearer <token>` | 预获取的 OAuth / Azure AD 令牌 |
| `azure-cli` | `Authorization: Bearer <token>` | 通过 `az account get-access-token` 获取的令牌 |
| `azure-ad` | `Authorization: Bearer <token>` | 通过 OAuth2 客户端凭据流程获取的令牌 |

**示例 — 通过环境变量使用 PAT：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "basic-pat",
  "token_env": "AZURE_DEVOPS_PAT"
}
```

**示例 — Azure CLI（交互式登录）：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "azure-cli"
}
```

需预先运行 `az login`。

**示例 — Azure AD 服务主体（CI/自动化）：**

```json
{
  "hosts": ["dev.azure.com"],
  "provider": "azure-devops",
  "auth": "azure-ad",
  "tenant_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "client_id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "client_secret_env": "AZURE_CLIENT_SECRET"
}
```

## 多个条目

你可以为不同主机或组织配置多个条目：

```json
{
  "providers": [
    {
      "hosts": ["github.com", "api.github.com", "raw.githubusercontent.com", "codeload.github.com"],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    },
    {
      "hosts": ["dev.azure.com"],
      "provider": "azure-devops",
      "auth": "basic-pat",
      "token_env": "AZURE_DEVOPS_PAT"
    }
  ]
}
```

## 工作原理

1. 对于每个出站 HTTP 请求，URL 主机名会与 `auth.json` 中的 `hosts` 模式进行匹配。
2. 如果找到匹配项，对应的提供者解析令牌并附加相应的 `Authorization` 请求头。
3. 如果请求收到 401 或 403，则尝试下一个匹配的条目。
4. 在所有匹配条目尝试完毕后，最终会尝试一次未认证的请求作为最后回退。
5. 在重定向时，如果重定向目标离开条目声明的 hosts 范围，则 `Authorization` 请求头会被剥离 — 防止凭据泄露到 CDN 或第三方服务。

## 模板

一份预配置 GitHub 的参考 `auth.json`：

```json
{
  "providers": [
    {
      "hosts": [
        "github.com",
        "api.github.com",
        "raw.githubusercontent.com",
        "codeload.github.com"
      ],
      "provider": "github",
      "auth": "bearer",
      "token_env": "GH_TOKEN"
    }
  ]
}
```

使用方法：

```bash
mkdir -p ~/.specify
# 将上述 JSON 复制到 ~/.specify/auth.json
chmod 600 ~/.specify/auth.json
```

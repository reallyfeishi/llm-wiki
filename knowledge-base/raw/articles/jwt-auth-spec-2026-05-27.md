# JWT 双 Token 认证架构规范

> 版本: 1.0
> 日期: 2026-05-27
> 状态: 已批准

## 概述

本规范定义系统认证架构，采用 JWT 双 Token 策略，平衡安全性与用户体验。

## Token 类型

### Access Token

- 类型: JWT (RS256 签名)
- 有效期: 15 分钟
- 用途: API 请求鉴权
- 携带位置: HTTP Authorization Header `Bearer <token>`
- Payload 示例:

```json
{
  "sub": "user-123",
  "role": "admin",
  "exp": 1716800000,
  "iat": 1716799100
}
```

### Refresh Token

- 类型: 随机字符串 (256-bit)
- 有效期: 7 天
- 用途: 获取新的 Access Token
- 存储位置: HttpOnly, Secure Cookie
- 刷新接口: `POST /api/auth/refresh`

## 刷新流程

1. 客户端携带 Refresh Token 请求 `/api/auth/refresh`
2. 服务端验证 Refresh Token 未过期且未被吊销
3. 生成新的 Access Token 返回
4. 如果 Refresh Token 已过期，返回 401，客户端跳转登录页

## 安全约束

- Access Token 不得存储于 localStorage（防 XSS）
- Refresh Token 必须设置 HttpOnly + Secure 标志
- 同一 Refresh Token 不得并发使用（第二次使用视为泄露，吊销该用户所有 Token）
- 密码重置后，该用户所有历史 Token 立即失效

## 性能指标

- Token 签发平均耗时: < 5ms (P99 < 12ms)
- 刷新接口响应时间: < 50ms (P99 < 100ms)
- 预计日刷新量: 10,000 次（按 5,000 DAU 计算）

## 异常处理

| 场景 | 状态码 | 行为 |
|------|--------|------|
| Access Token 过期 | 401 | 客户端自动尝试刷新 |
| Refresh Token 过期 | 401 | 跳转登录页 |
| Refresh Token 被吊销 | 403 | 跳转登录页 + 提示"账号异常" |
| 并发刷新检测 | 403 | 吊销所有 Token + 通知用户 |

## 附录: 行号参考

本文档共 45 行（含标题和空行）。关键行号:
- L12-L17: Access Token 规范
- L20-L25: Refresh Token 规范
- L28-L34: 刷新流程
- L36-L40: 安全约束
- L42-L44: 性能指标

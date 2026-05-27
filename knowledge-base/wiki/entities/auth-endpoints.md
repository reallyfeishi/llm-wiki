---
title: "认证端点"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/articles/jwt-auth-spec-2026-05-27.md
    lines: "L28-L34,L46-L52"
    ingested: 2026-05-27
tags: [auth, api, endpoints]
category: entity
links_to: [jwt-auth-patterns]
linked_from: [jwt-auth-patterns]
status: active
---

# 认证端点

> JWT 双 Token 架构中的 API 端点定义。

## 刷新接口

**端点**: `POST /api/auth/refresh`

**请求**: 携带 Refresh Token（HttpOnly Cookie 自动发送）

**响应**:
- 成功: 返回新的 Access Token^[jwt-auth-spec-2026-05-27.md:L30-L32]
- Refresh Token 过期: 401，客户端跳转登录页^[jwt-auth-spec-2026-05-27.md:L34]
- Refresh Token 被吊销: 403，跳转登录页 + 提示"账号异常"^[jwt-auth-spec-2026-05-27.md:L49]
- 并发刷新检测: 403，吊销所有 Token + 通知用户^[jwt-auth-spec-2026-05-27.md:L50]

## 性能要求

- 刷新接口响应时间: < 50ms (P99 < 100ms)^[jwt-auth-spec-2026-05-27.md:L43]
- 预计日处理量: 10,000 次^[jwt-auth-spec-2026-05-27.md:L44]

## 相关页面

- [[jwt-auth-patterns]]

## 来源

- raw/articles/jwt-auth-spec-2026-05-27.md, L28-L34,L46-L52

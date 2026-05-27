---
title: "JWT 双 Token 认证模式"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/articles/jwt-auth-spec-2026-05-27.md
    lines: "L1-L45"
    ingested: 2026-05-27
tags: [auth, jwt, security, token]
category: concept
links_to: [auth-endpoints]
linked_from: [auth-endpoints]
status: active
---

# JWT 双 Token 认证模式

> 采用 Access Token（短期）+ Refresh Token（长期）的双 Token 策略，平衡安全性与用户体验。

## Token 设计

**Access Token**：JWT (RS256 签名)，有效期 15 分钟，用于 API 请求鉴权，携带于 HTTP Authorization Header。^[jwt-auth-spec-2026-05-27.md:L12-L17]

**Refresh Token**：256-bit 随机字符串，有效期 7 天，存储于 HttpOnly + Secure Cookie，用于获取新的 Access Token。^[jwt-auth-spec-2026-05-27.md:L20-L25]

## 刷新流程

1. 客户端携带 Refresh Token 请求 `/api/auth/refresh`
2. 服务端验证 Refresh Token 未过期且未被吊销
3. 生成新的 Access Token 返回
4. Refresh Token 过期时返回 401，客户端跳转登录页^[jwt-auth-spec-2026-05-27.md:L28-L34]

## 安全约束

- Access Token 不得存储于 localStorage（防 XSS）^[jwt-auth-spec-2026-05-27.md:L36]
- Refresh Token 必须设置 HttpOnly + Secure 标志^[jwt-auth-spec-2026-05-27.md:L37]
- 同一 Refresh Token 不得并发使用（第二次使用视为泄露，吊销该用户所有 Token）^[jwt-auth-spec-2026-05-27.md:L38]
- 密码重置后，该用户所有历史 Token 立即失效^[jwt-auth-spec-2026-05-27.md:L39]

## 性能指标

- Token 签发平均耗时: < 5ms (P99 < 12ms)^[jwt-auth-spec-2026-05-27.md:L42]
- 刷新接口响应时间: < 50ms (P99 < 100ms)^[jwt-auth-spec-2026-05-27.md:L43]
- 预计日刷新量: 10,000 次（按 5,000 DAU 计算）^[jwt-auth-spec-2026-05-27.md:L44]

## 相关页面

- [[auth-endpoints]]

## 来源

- raw/articles/jwt-auth-spec-2026-05-27.md, L1-L45

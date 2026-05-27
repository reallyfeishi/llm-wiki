---
name: wiki-search
description: LLM Wiki 分层搜索工具。通过 grep 和 qmd 在知识库中检索相关页面。
---

# Wiki 搜索工具

## 搜索策略（三层）

### 第一层：index.md 确定性匹配

```bash
# 读取目录，匹配标题和标签
# 适用于 < 50 条目的 wiki
cat knowledge-base/wiki/index.md
```

### 第二层：grep 全文搜索（默认）

```bash
# 按关键词搜索 wiki 页面内容
grep -rn "关键词" knowledge-base/wiki/

# 按标签搜索 front matter
grep -rn "tags:.*auth" knowledge-base/wiki/

# 搜索特定 source 引用
grep -rn "jwt-auth-spec" knowledge-base/wiki/

# 搜索 wiki 链接
grep -rn "\[\[jwt-auth\]\]" knowledge-base/wiki/

# 限制结果数量
grep -rn "认证" knowledge-base/wiki/ | head -20
```

### 第三层：qmd 语义搜索（可选）

当 wiki 规模超过 100 页面时推荐安装 qmd。

**安装**:
```bash
npm install -g qmd
# 或作为 MCP Server 安装
```

**CLI 用法**:
```bash
# BM25 + 向量混合搜索
qmd search "认证是怎么做的" --dir knowledge-base/wiki/

# 仅 BM25 关键词搜索
qmd search "JWT token" --dir knowledge-base/wiki/ --mode bm25
```

**MCP Server 用法** (添加到 `~/.claude/settings.json`):
```json
{
  "mcpServers": {
    "qmd-search": {
      "command": "qmd",
      "args": ["mcp-server", "--dir", "knowledge-base/wiki/"]
    }
  }
}
```

## 搜索工作流

```
用户查询 → 读 index.md 确定性匹配
→ 匹配不足时用 grep 搜索 wiki/
→ 如果安装了 qmd，用语义搜索补充
→ 综合结果，返回带引用的回答
```

## 核心原则

- **确定性检索 + 概率性推理**
- "找"的部分交给工具（grep/qmd）
- "想"的部分交给 AI（在检索结果上综合推理）
- 每条结论必须附带来源引用

---
name: llm-wiki
description: 持久化、带溯源的个人知识库。支持写入（ingest/add）、查询（query）、维护（lint/health）、浏览（list/read）。通过行号级引用防漂移，通过体检防孤岛，通过分层搜索防找不到。
triggers: ["wiki", "wiki ingest", "wiki add", "wiki query", "wiki lint", "wiki health", "wiki deep-check", "wiki list", "wiki read"]
---

# LLM Wiki Skill

 Andrej Karpathy 提出的 LLM Wiki 模式的 Claude Code 实现。
核心理念：**确定性检索 + 概率性推理**。AI 是园丁，人类拥有验证权。

## 知识库位置

`knowledge-base/` 目录（项目根目录）

## 可用操作

| 操作 | 触发词 | 描述 |
|------|--------|------|
| 写入 | `wiki ingest` | 处理 raw/ 中的文档，生成带溯源的 wiki 页面 |
| 快速添加 | `wiki add` | 快速添加单个 wiki 页面 |
| 查询 | `wiki query` | 从知识库搜索并综合回答 |
| 每周体检 | `wiki lint` | 快速检查：孤岛、断链、过时、矛盾、索引膨胀 |
| 每月深检 | `wiki deep-check` | 深度检查：随机抽样逐条比对源文件 |
| 列表 | `wiki list` | 显示 index.md 目录 |
| 读取 | `wiki read` | 读取指定页面 |

## 目录结构

```
knowledge-base/
├── raw/           # 原始文档（不可变）
├── wiki/
│   ├── index.md   # 目录（< 50 条目）
│   ├── log.md     # 溯源日志
│   ├── concepts/  # 概念、模式、原则
│   ├── entities/  # 服务、模块、API
│   ├── decisions/ # ADR 决策
│   └── sources/   # 源文档摘要
└── search/        # 搜索索引（git 忽略）
```

## 工作流

### wiki ingest
1. 读取指定的 raw/ 文档
2. 按 schema 提取概念/实体/决策
3. 创建 wiki 页面（frontmatter + 行号引用）
4. 更新 index.md、反向链接、log.md
5. 等待用户审核

### wiki query
1. 读 index.md 确定性匹配
2. 不足时用 grep 搜索 wiki/
3. 读取匹配页面全文
4. 在检索结果上综合推理
5. 返回带引用的回答

### wiki lint
1. 扫描孤立页面、断裂链接、过时内容
2. 检查覆盖率缺口、索引膨胀
3. 矛盾检测
4. 生成 lint-report-YYYY-MM-DD.md

### wiki deep-check
1. 随机抽样 5 个 wiki 页面
2. 逐条比对源文件对应行
3. 生成 drift report
4. 逐条请求用户确认修复

## 搜索策略（分层）

1. **第一层**：index.md 确定性匹配（< 50 条目）
2. **第二层**：`grep -rn "关键词" knowledge-base/wiki/`
3. **第三层**：qmd BM25 + 向量混合搜索（> 100 页面可选）

## 引用格式

- **行内引用**：`^[filename:L-L]`
- **来源标注**：`-- raw/filename.md, L128`
- **Wiki 链接**：`[[page-slug]]`

## 规则

详见 AGENTS.md。核心三条：
1. 每个关键事实必须标注来源行号
2. 数字/百分比/结论不得用 AI 的话重述
3. 没有来源的断言标记为 `[推测]`

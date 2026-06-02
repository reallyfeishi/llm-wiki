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
├── {project-name}/           # 按项目分类（如 narrative_forge、auth）
│   ├── raw/
│   │   └── notes/
│   │       ├── {name}-{YYYY-MM-DD}.md      # 最新快照（带日期）
│   │       └── archive/                     # 历史版本（最多保留 3 个）
│   │           ├── {name}-{old-date}.md
│   │           └── ...
│   └── wiki/
│       ├── index.md          # 项目目录
│       ├── concepts/         # 概念、模式、原则
│       ├── entities/         # 服务、模块、API
│       └── decisions/        # ADR 决策
├── wiki/                     # 通用/独立页面（不属于特定项目）
│   ├── index.md              # 总目录
│   └── log.md                # 溯源日志
└── search/                   # 搜索索引（git 忽略）
```

- 每个项目拥有独立的 `raw/` 和 `wiki/`
- `knowledge-base/wiki/index.md` 是总目录，引用所有项目的页面
- `sources.path` 使用相对于 wiki 页面的路径（如 `../raw/notes/xxx.md`）

## 工作流

### wiki ingest（首次摄入）
1. 在 `knowledge-base/` 下创建 `{project-name}/` 目录（如不存在）
2. 生成快照 `{project-name}/raw/notes/项目名-YYYY-MM-DD.md`
3. 读取指定的 raw/ 文档
4. 按 schema 提取概念/实体/决策
5. 创建 wiki 页面到 `{project-name}/wiki/`（frontmatter + 行号引用）
6. 更新项目 `index.md`、总 `index.md`、反向链接、log.md
7. 等待用户审核

### wiki ingest（更新模式）
1. 生成新快照 `{project-name}/raw/notes/项目名-YYYY-MM-DD.md`
2. 将旧版本移入 `{project-name}/raw/notes/archive/`
3. 检查 archive/ 数量，超过 3 个时删除最旧的一个
4. 对比新 raw 与旧 raw 的差异
5. 更新受影响的 wiki 页面（修正事实、更新 `sources.path` 指向最新 raw）
6. 更新 wiki 页面的 `updated` 日期和 `ingested` 日期
7. 更新项目 `index.md` 和总 `index.md`，以及 `log.md`
8. 等待用户审核

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

1. **第一层**：`knowledge-base/wiki/index.md` 总目录确定性匹配
2. **第二层**：`grep -rn "关键词" knowledge-base/*/wiki/` 按项目搜索
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

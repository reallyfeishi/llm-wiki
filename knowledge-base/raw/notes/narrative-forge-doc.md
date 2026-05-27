# NarrativeForge 项目文档

> AI 辅助长篇叙事写作工具
> 版本: 0.1.0-dev
> 语言: Python
> 架构: 4 层分层架构 + 知识图谱

## 项目概述

NarrativeForge 是一个 CLI 工具，通过 LLM + Neo4j 知识图谱 + ChromaDB 向量存储，辅助长篇叙事写作的创作和一致性维护。

## 架构设计

### 分层架构

```
Layer 1: World Building (世界构建)
  └── Bible Parser → KG Builder → State Tracker → Constraint Engine

Layer 2: Generation (生成) — TODO

Layer 3: Review (审查) — TODO

Layer 4: Learning (学习) — TODO
```

### 基础设施

```
LLM Client (LiteLLM) — 统一 LLM 调用接口
Neo4j Client — 知识图谱存储
Vector Store (ChromaDB) — 语义搜索
```

## CLI 命令

| 命令 | 描述 | 状态 |
|------|------|------|
| `init` | 初始化项目 | 已实现 |
| `import` | 导入故事圣经/大纲 | 已实现 |
| `kg` | 知识图谱管理 | 已实现 |
| `state` | 状态管理 | 已实现 |
| `validate` | 验证一致性 | 已实现 |
| `write` | 生成章节 | TODO |
| `review` | 审查章节 | TODO |
| `export` | 导出文件 | TODO |

## 技术栈

- Neo4j 5.26 + APOC 插件
- ChromaDB (向量存储)
- LiteLLM (LLM 路由)
- pydantic 2.0+
- tenacity (重试)
- tiktoken + jieba (文本处理)
- sentence-transformers (嵌入)
- python-docx + markdown (导出)

## 环境要求

- NEO4J_URI=bolt://localhost:7687
- LITELLM_API_KEY / LITELLM_API_BASE / LITELLM_MODEL
- CHROMA_HOST=localhost, CHROMA_PORT=8000

## 核心流程

1. 初始化项目 (`init`)
2. 导入故事圣经 (`import --bible`) → BibleParser 解析 → KGBuilder 建图
3. 导入大纲 (`import --outline`) → LLM 提取章节结构 → 建图
4. 查询知识图谱 (`kg status/query`)
5. 管理角色状态 (`state show/diff`)
6. 验证一致性 (`validate`)

---
title: "NarrativeForge 技术栈"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L36-L50"
    ingested: 2026-05-27
tags: [narrative-forge, tech-stack, infrastructure]
category: concept
links_to: [narrative-forge-overview]
linked_from: [narrative-forge-overview]
status: active
---

# NarrativeForge 技术栈

> 项目使用的核心技术组件及配置。

## 数据存储

| 组件 | 版本 | 用途 | 端口 |
|------|------|------|------|
| Neo4j | 5.26 | 知识图谱存储，含 APOC 插件 | 7474 (HTTP), 7687 (Bolt)^[narrative-forge-doc.md:L47] |
| ChromaDB | latest | 向量存储，语义搜索 | 8000^[narrative-forge-doc.md:L48] |

## Python 依赖

| 包 | 用途 |
|----|------|
| neo4j >= 5.14.0 | Neo4j 驱动 |
| litellm >= 1.80.10 | LLM 统一客户端 |
| chromadb >= 0.4.0 | 向量存储 |
| sentence-transformers >= 2.2.0 | 嵌入模型 |
| pydantic >= 2.0.0 | 数据验证 |
| tenacity >= 8.2.0 | 重试机制 |
| tiktoken >= 0.8.0 | Token 计数 |
| jieba >= 0.42.1 | 中文分词 |
| python-docx >= 1.0.0 | Word 导出 |
| markdown >= 3.4.0 | Markdown 处理 |

^[narrative-forge-doc.md:L36-L45]

## 环境变量

- `NEO4J_URI` — 默认 `bolt://localhost:7687`^[narrative-forge-doc.md:L47]
- `LITELLM_API_KEY` / `LITELLM_API_BASE` / `LITELLM_MODEL` — LLM 配置^[narrative-forge-doc.md:L48]
- `MODEL_GENERATION` / `MODEL_REVIEW` — 模型路由 (可选)^[narrative-forge-doc.md:L48]
- `CHROMA_HOST` / `CHROMA_PORT` — 默认 localhost:8000^[narrative-forge-doc.md:L49]

## 相关页面

- [[narrative-forge-overview]]

## 来源

- raw/notes/narrative-forge-doc.md, L36-L50

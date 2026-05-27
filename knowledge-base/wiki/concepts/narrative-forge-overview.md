---
title: "NarrativeForge 项目概述"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L1-L60"
    ingested: 2026-05-27
tags: [narrative-forge, project, architecture]
category: concept
links_to: [nf-cli-commands, nf-layer1-world, nf-kg-builder, nf-tech-stack]
linked_from: [nf-cli-commands, nf-layer1-world, nf-kg-builder, nf-tech-stack]
status: active
---

# NarrativeForge 项目概述

> AI 辅助长篇叙事写作工具，通过 LLM + Neo4j 知识图谱 + ChromaDB 向量存储，维护长篇小说的一致性。^[narrative-forge-doc.md:L5]

## 核心能力

- **故事圣经解析**：支持 MD/JSON/YAML 格式，用 LLM 提取结构化信息^[narrative-forge-doc.md:L36]
- **知识图谱构建**：角色、地点、势力、物品、世界规则的 Neo4j 图存储^[narrative-forge-doc.md:L37]
- **状态追踪**：追踪角色在各章节的位置、生死、物品状态^[narrative-forge-doc.md:L43]
- **一致性验证**：检查死角色出现、位置冲突、世界规则违反^[narrative-forge-doc.md:L44]

## 4 层架构

1. **Layer 1: World Building** — BibleParser → KGBuilder → StateTracker → ConstraintEngine^[narrative-forge-doc.md:L12]
2. **Layer 2: Generation** — 章节生成 (TODO)^[narrative-forge-doc.md:L14]
3. **Layer 3: Review** — 多代理审查 (TODO)^[narrative-forge-doc.md:L15]
4. **Layer 4: Learning** — 持续学习 (TODO)^[narrative-forge-doc.md:L16]

## 基础设施

- LLMClient (LiteLLM) — 统一 LLM 调用，支持重试和 Token 计数^[narrative-forge-doc.md:L20]
- Neo4jClient — 知识图谱 CRUD^[narrative-forge-doc.md:L21]
- VectorStore (ChromaDB) — 语义搜索^[narrative-forge-doc.md:L22]

## 相关页面

- [[nf-cli-commands]]
- [[nf-layer1-world]]
- [[nf-kg-builder]]
- [[nf-tech-stack]]

## 来源

- raw/notes/narrative-forge-doc.md, L1-L60

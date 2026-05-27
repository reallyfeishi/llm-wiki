---
title: "KGBuilder 知识图谱构建器"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L36-L37"
    ingested: 2026-05-27
tags: [narrative-forge, kg, neo4j, knowledge-graph]
category: entity
links_to: [nf-layer1-world, nf-tech-stack]
linked_from: [narrative-forge-overview, nf-layer1-world]
status: active
---

# KGBuilder 知识图谱构建器

> 将解析后的故事圣经构建为 Neo4j 知识图谱。^[narrative-forge-doc.md:L37]

## 支持的实体类型

| 节点类型 | 属性 | 关系 |
|----------|------|------|
| Story | id, title, genre | HAS_CHARACTER, HAS_LOCATION^[narrative-forge-doc.md:L37] |
| Character | name, aliases, personality, skills, status, gender | LOCATED_AT, OWNS |
| Location | name, type, description, parent | — |
| Faction | name, type, leader, description | — |
| Item | name, type, abilities, description, owner | OWNS |
| WorldRule | name, category, description, exceptions | — |
| Chapter | number, title, synopsis | — |
| Scene | chapter_num, synopsis, location, characters | — |

^[narrative-forge-doc.md:L36-L37]

## 核心方法

- `build(bible, story_id)` — 完整构建流程：创建 Story 根节点 → 创建各类型实体 → 建立默认关系^[narrative-forge-doc.md:L37]
- `build_outline(outline_text, story_id)` — 用 LLM 从大纲文本提取章节结构并建图^[narrative-forge-doc.md:L36]
- `extract_and_build_from_text(text, story_id)` — 从任意文本提取并构建 KG^[narrative-forge-doc.md:L37]

## 相关页面

- [[nf-layer1-world]]
- [[nf-tech-stack]]

## 来源

- raw/notes/narrative-forge-doc.md, L36-L37

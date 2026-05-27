---
title: "Layer 1 世界构建模块"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L12-L17"
    ingested: 2026-05-27
tags: [narrative-forge, layer1, world-building]
category: entity
links_to: [narrative-forge-overview, nf-kg-builder, nf-state-tracker, nf-constraint-engine]
linked_from: [narrative-forge-overview]
status: active
---

# Layer 1 世界构建模块

> 叙事系统的核心层，负责从故事圣经构建并维护世界知识。^[narrative-forge-doc.md:L12]

## 数据流

```
故事圣经文件 (MD/JSON/YAML)
    ↓
BibleParser — 解析并提取结构化数据
    ↓
KGBuilder — 将解析结果构建为 Neo4j 知识图谱
    ↓
StateTracker — 追踪角色/物品的状态变化
    ↓
ConstraintEngine — 验证内容是否违反世界规则
```

^[narrative-forge-doc.md:L36-L37]

## 模块文件

- `layer1_world/bible_parser.py` — BibleParser 类
- `layer1_world/kg_builder.py` — KGBuilder 类
- `layer1_world/state_tracker.py` — StateTracker 类
- `layer1_world/constraint_engine.py` — ConstraintEngine 类

^[narrative-forge-doc.md:L12-L17]

## 相关页面

- [[narrative-forge-overview]]
- [[nf-kg-builder]]
- [[nf-state-tracker]]
- [[nf-constraint-engine]]

## 来源

- raw/notes/narrative-forge-doc.md, L12-L17

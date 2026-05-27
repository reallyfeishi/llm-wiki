---
title: "StateTracker 状态追踪器"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L42-L43"
    ingested: 2026-05-27
tags: [narrative-forge, state, tracking]
category: entity
links_to: [nf-layer1-world]
linked_from: [narrative-forge-overview, nf-layer1-world]
status: active
---

# StateTracker 状态追踪器

> 动态追踪角色/物品在叙事中的状态变化。^[narrative-forge-doc.md:L42]

## 核心方法

- `get_character_state(name, chapter)` — 获取角色在指定章节的状态（位置、生死、物品）^[narrative-forge-doc.md:L43]
- `update_character_state(name, chapter, status, location, inventory_changes)` — 更新角色状态^[narrative-forge-doc.md:L43]
- `get_all_states(chapter)` — 获取所有角色在指定章节的状态^[narrative-forge-doc.md:L43]
- `diff_states(from_chapter, to_chapter)` — 比较两章节间状态变化（新增、死亡、移动、状态变更）^[narrative-forge-doc.md:L43]

## 追踪内容

- 角色位置：通过 LOCATED_AT 关系的 chapter 属性记录^[narrative-forge-doc.md:L43]
- 角色状态：alive/dead/unknown^[narrative-forge-doc.md:L43]
- 物品所有权：通过 OWNS 关系的 chapter 属性记录^[narrative-forge-doc.md:L43]

## 相关页面

- [[nf-layer1-world]]

## 来源

- raw/notes/narrative-forge-doc.md, L42-L43

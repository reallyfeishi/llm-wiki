---
title: "ConstraintEngine 约束规则引擎"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L43-L44"
    ingested: 2026-05-27
tags: [narrative-forge, constraint, validation]
category: entity
links_to: [nf-layer1-world, nf-cli-commands]
linked_from: [narrative-forge-overview, nf-layer1-world]
status: active
---

# ConstraintEngine 约束规则引擎

> 检查叙事内容是否违反预设的世界规则和逻辑约束。^[narrative-forge-doc.md:L44]

## 检查类型

| 检查项 | 严重级别 | 描述 |
|--------|----------|------|
| 死角色出现 | CRITICAL | 已死亡角色在后续章节文本中出现^[narrative-forge-doc.md:L44] |
| 位置一致性 | HIGH | 角色不能同时出现在两个地点^[narrative-forge-doc.md:L44] |
| 世界规则 | 待定 | LLM 辅助判断是否违反世界规则 (Phase 3+)^[narrative-forge-doc.md:L44] |
| 因果一致性 | HIGH | 事件的原因必须在结果之前^[narrative-forge-doc.md:L44] |

## 核心方法

- `validate_chapter(text, chapter)` — 验证章节内容，返回违规列表^[narrative-forge-doc.md:L44]
- `check_temporal_consistency(events)` — 检查事件时间线一致性^[narrative-forge-doc.md:L44]

## CLI 使用

```bash
narrative-forge validate -c 3    # 验证第 3 章
narrative-forge validate          # 验证所有章节
```

^[narrative-forge-doc.md:L30]

## 相关页面

- [[nf-layer1-world]]
- [[nf-cli-commands]]

## 来源

- raw/notes/narrative-forge-doc.md, L43-L44

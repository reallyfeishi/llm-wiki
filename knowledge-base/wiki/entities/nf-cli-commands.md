---
title: "NarrativeForge CLI 命令"
created: 2026-05-27
updated: 2026-05-27
sources:
  - path: raw/notes/narrative-forge-doc.md
    lines: "L24-L34"
    ingested: 2026-05-27
tags: [narrative-forge, cli, commands]
category: entity
links_to: [narrative-forge-overview]
linked_from: [narrative-forge-overview]
status: active
---

# NarrativeForge CLI 命令

> 项目提供的 8 个 CLI 命令及其实现状态。

## 已实现命令

| 命令 | 描述 | 关键参数 |
|------|------|----------|
| `init` | 初始化项目 | `--name`, `--genre`, `--language`^[narrative-forge-doc.md:L26] |
| `import` | 导入故事圣经/大纲 | `--bible`, `--outline`, `--format`^[narrative-forge-doc.md:L27] |
| `kg` | 知识图谱管理 | `status`/`query`/`build`, `-q`^[narrative-forge-doc.md:L28] |
| `state` | 状态管理 | `show`/`diff`, `-c`, `--from-chapter`, `--to-chapter`^[narrative-forge-doc.md:L29] |
| `validate` | 验证一致性 | `-c` (章节号)^[narrative-forge-doc.md:L30] |

## TODO 命令

| 命令 | 描述 | 计划 |
|------|------|------|
| `write` | 生成章节 | Phase 3 实现^[narrative-forge-doc.md:L31] |
| `review` | 审查章节 | Phase 4 实现^[narrative-forge-doc.md:L32] |
| `export` | 导出文件 | Phase 6 实现，支持 txt/md/docx^[narrative-forge-doc.md:L33] |

## 核心工作流

```
init → import --bible → import --outline → kg status → state show → validate
```

^[narrative-forge-doc.md:L36-L44]

## 相关页面

- [[narrative-forge-overview]]

## 来源

- raw/notes/narrative-forge-doc.md, L24-L34

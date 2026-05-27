# Knowledge Base

这是本项目的 LLM Wiki。所有知识持久化存储为 Markdown 文件。

## 原则

- **人类拥有验证权**，AI 是园丁
- **确定性检索 + 概率性推理**
- 每个关键事实必须有来源标注
- 数字、百分比、具体结论不得用 AI 的话重述

## 结构

- `raw/` -- 原始文档（不可修改，只读）
- `wiki/` -- 压缩后的知识页面
- `wiki/index.md` -- 目录（保持 < 50 条目）
- `wiki/log.md` -- 溯源日志（只追加）

## 操作

通过 `wiki` 触发词调用 LLM Wiki Skill：
- `wiki ingest` -- 写入知识
- `wiki query` -- 查询知识
- `wiki lint` -- 每周体检
- `wiki deep-check` -- 每月深检

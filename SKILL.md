---
name: llm-wiki
description: LLM Wiki 知识库操作。支持 ingest(写入文档)、query(查询知识)、lint(每周体检)、deep-check(每月深检)、list(查看目录)、read(读取页面)。通过行号级溯源防漂移，通过体检防孤岛，通过分层搜索防找不到。
---

# LLM Wiki Skill

Andrej Karpathy 提出的 LLM Wiki 模式的 Claude Code 实现。
核心理念：**确定性检索 + 概率性推理**。AI 是园丁，人类拥有验证权。

## 知识库位置

`D:\yuanma\llm-wiki\knowledge-base\`

## 可用操作

| 操作 | 描述 |
|------|------|
| **ingest** | 处理 raw/ 中的文档，生成带溯源的 wiki 页面 |
| **add** | 快速添加单个 wiki 页面 |
| **query** | 从知识库搜索并综合回答 |
| **lint** | 快速检查：孤岛、断链、过时、矛盾、索引膨胀 |
| **deep-check** | 深度检查：随机抽样逐条比对源文件 |
| **list** | 显示 index.md 目录 |
| **read** | 读取指定页面 |

## 工作流

### ingest
1. 读取指定的 raw/ 文档或项目文件
2. 按 schema 提取概念/实体/决策
3. 创建 wiki 页面（frontmatter + 行号引用）
4. 更新 index.md、反向链接、log.md
5. 等待用户审核

### query
1. 读 index.md 确定性匹配
2. 不足时用 grep 搜索 wiki/
3. 读取匹配页面全文
4. 在检索结果上综合推理
5. 返回带引用的回答

### lint
1. 运行 `bash skill/scripts/health-check.sh knowledge-base/`
2. 读取生成的 lint-report-YYYY-MM-DD.md
3. AI 执行矛盾检测（语义分析）
4. 向用户报告问题，等待决定

### deep-check
1. 随机抽样 5 个 wiki 页面
2. 逐条比对源文件对应行
3. 生成 drift report
4. 逐条请求用户确认修复

## 引用格式

- **行内引用**：`^[filename:L-L]`
- **来源标注**：`-- raw/filename.md, L128`
- **Wiki 链接**：`[[page-slug]]`

## 规则

详见 skill/AGENTS.md。核心三条：
1. 每个关键事实必须标注来源行号
2. 数字/百分比/结论不得用 AI 的话重述
3. 没有来源的断言标记为 `[推测]`

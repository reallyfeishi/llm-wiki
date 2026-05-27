# LLM Wiki

基于 Andrej Karpathy [LLM Wiki 模式](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) 的 Claude Code Skill 实现。

AI 是园丁，人类拥有验证权。

## 核心理念

**确定性检索 + 概率性推理**。

LLM Wiki 不同于传统 RAG（每次查询时从原始文档中检索），它采用"写入时处理"模式：将文档编译成持久化的、相互链接的 Markdown Wiki。知识随时间持续积累、演化和交叉链接。

## 核心特性

### 三个结构性问题，三个解法

| 问题 | 解法 | 机制 |
|------|------|------|
| **漂移** — Wiki 页面与原始文档逐渐脱节，AI 摘要是有损压缩 | **行号级溯源** | 每个关键事实标注来源文件 + 行号 `^[file.md:L28-L32]`，1 秒跳到原文验证 |
| **孤岛** — 写完就没人引用的页面等于"死了" | **定期体检** | 每周快速检查（孤立/断链/过时/矛盾）+ 每月深度检查（逐条比对源文件） |
| **找不到** — 目录超过 50 页后 AI 检索效率下降 | **分层搜索** | index.md 确定性匹配 → grep 全文搜索 → qmd 语义搜索（可选） |

## 安装

### 前提条件

- [Claude Code](https://claude.ai/code)
- Bash 环境（Windows 可用 Git Bash）

### 步骤

1. **克隆仓库**

```bash
git clone https://github.com/reallyfeishi/llm-wiki.git
cd llm-wiki
```

2. **复制 Skill 到 Claude Code 配置目录**

```bash
# Windows
xcopy /E /I skill\* "%USERPROFILE%\.claude\skills\llm-wiki\"

# Linux / macOS
cp -r skill/* ~/.claude/skills/llm-wiki/
```

3. **初始化知识库**

```bash
mkdir -p knowledge-base/raw/{articles,notes,papers}
mkdir -p knowledge-base/wiki/{concepts,entities,decisions,sources}
mkdir -p knowledge-base/search

# 创建初始文件
echo "# Knowledge Base" > knowledge-base/CLAUDE.md
echo "# Wiki Index" > knowledge-base/wiki/index.md
echo "# Wiki Operation Log" > knowledge-base/wiki/log.md
```

4. **验证安装**

在 Claude Code 中输入 `/wiki-` 后按 Tab，应能看到 7 个子指令的自动补全。

## 使用

### 7 个斜杠指令

| 指令 | 功能 |
|------|------|
| `/wiki-ingest` | 将文档或项目文件写入知识库（带行号级溯源） |
| `/wiki-query` | 搜索知识并综合回答 |
| `/wiki-lint` | 每周快速健康检查 |
| `/wiki-deep-check` | 每月深度健康检查 |
| `/wiki-list` | 查看知识库目录 |
| `/wiki-read` | 读取指定页面 |
| `/wiki-add` | 快速添加单个页面 |

### 快速开始

**写入知识**：
```
/wiki-ingest raw/articles/my-doc.md
```

**查询知识**：
```
/wiki-query Access Token 有效期是多久？
```

**健康检查**：
```
/wiki-lint
```

### 知识库目录结构

```
knowledge-base/
├── raw/                  # 原始文档（不可变，只读）
│   ├── articles/
│   ├── notes/
│   └── papers/
├── wiki/
│   ├── index.md          # 目录（保持 < 50 条目）
│   ├── log.md            # 溯源日志（只追加）
│   ├── concepts/         # 抽象概念、模式、原则
│   ├── entities/         # 具体事物：服务、模块、API
│   ├── decisions/        # 决策记录（ADR）
│   └── sources/          # 源文档摘要
└── search/               # 搜索索引（git 忽略）
```

## 溯源格式

每个关键事实带行号级引用：

```markdown
系统使用 JWT 双 token 策略：access_token 有效期 15 分钟，
refresh_token 有效期 7 天。^[jwt-auth-spec.md:L28-L32]
```

AGENTS.md 硬规则：
1. 数字、百分比、具体结论必须原文引用，不得用 AI 的话重述
2. 没有来源的断言标记为 `[推测]`
3. 前提条件不得省略

## 与其他方案的对比

| 维度 | 本方案 | nashsu/llm_wiki | luotwo/llm-wiki | 传统 RAG |
|------|--------|-----------------|-----------------|----------|
| **运行时** | 无（Claude Code 本身是引擎） | 桌面应用（Tauri） | Claude Code Skill | 向量数据库 + Embedding 服务 |
| **存储** | 纯 Markdown | Markdown + YAML front matter | Markdown | 向量数据库 |
| **溯源** | 行号级（`^[file:L-L]`） | 行号级（`^[file:L-L]`） | log.md + 行号 | 文档级引用 |
| **健康检查** | Shell 脚本 + AI 语义分析 | 内置 lint 工具 | AI 驱动（无脚本） | 无 |
| **搜索** | index.md → grep → qmd | 内置自然语言搜索 | index.md | 向量检索 |
| **依赖** | 零 | Tauri + TypeScript | 零 | 向量数据库 + Embedding 模型 |
| **人类可读** | 任何编辑器 | 需桌面应用 | 任何编辑器 | 不可读 |
| **知识演化** | 持续积累 | 持续积累 | 持续积累 | 每次查询从头 |

## 创新之处

1. **行号级溯源**：不是"来自某个文档"，而是"来自某个文档的第 X 行到第 Y 行"，1 秒跳到原文验证

2. **脚本化体检**：健康检查不是纯 AI 驱动（不可靠、不透明），而是 Shell 脚本执行确定性检测（孤立页面、断裂链接、过时内容、覆盖率缺口、索引膨胀），加上 AI 语义矛盾检测

3. **确定性检索 + 概率性推理**：
   - "找"的部分交给确定性工具（grep/qmd）
   - "想"的部分交给 AI（在检索结果上综合推理）
   - 正如 @gulliveruk 所说：*确定范围应该是确定性的，推理应该是概率性的*

4. **纯 Markdown 零依赖**：没有数据库、没有嵌入模型、没有运行时服务。任何文本编辑器可读可写，任何 git 仓库可托管，任何 Claude Code 实例可操作

5. **7 个独立 Skill 支持自动补全**：每个操作（ingest/query/lint/deep-check/list/read/add）都是独立的 Claude Code Skill，输入 `/wiki-` 即可看到完整指令列表

## 灵感来源

- [Andrej Karpathy 的 LLM Wiki Gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)
- [nashsu/llm_wiki](https://github.com/nashsu/llm_wiki) — 跨平台桌面应用实现
- [luotwo/llm-wiki](https://github.com/luotwo/llm-wiki) — Claude Code Skill 实现
- 社区实践者的三周使用经验：漂移溯源、定期体检、分层搜索

## License

MIT

#!/bin/bash
# LLM Wiki 健康检查脚本
# 用途：快速检测孤岛页面、断裂链接、过时内容、索引膨胀、raw 版本膨胀

KB_DIR="knowledge-base"
REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="$KB_DIR/wiki/lint-report-$REPORT_DATE.md"

# 收集所有 wiki 页面（排除 raw/、search/、配置文件）
wiki_files=$(find "$KB_DIR" -name "*.md" \
    -not -path "*/raw/*" \
    -not -path "*/search/*" \
    -not -name "lint-report-*" \
    -not -name "index.md" \
    -not -name "log.md" \
    -not -name "CLAUDE.md" \
    -not -name "AGENTS.md" \
    -not -name "SKILL.md" \
    -not -name "schema.yaml")

echo "# Wiki 健康检查报告 - $REPORT_DATE" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 1. 孤立页面检测
echo "## 1. 孤立页面 (Orphan Pages)" >> "$REPORT_FILE"
orphan_count=0
for page in $wiki_files; do
    [ -f "$page" ] || continue
    slug=$(basename "$page" .md)
    found=false
    for other in $wiki_files "$KB_DIR/wiki/index.md"; do
        [ -f "$other" ] || continue
        grep -q "\[\[$slug\]\]" "$other" 2>/dev/null && found=true && break
    done
    if [ "$found" = false ]; then
        echo "- $page (未被任何其他页面链接)" >> "$REPORT_FILE"
        orphan_count=$((orphan_count + 1))
    fi
done
[ "$orphan_count" -eq 0 ] && echo "- 无孤立页面" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 2. 断裂链接检测
echo "## 2. 断裂链接 (Broken Links)" >> "$REPORT_FILE"
broken_count=0
links=$(for page in $wiki_files "$KB_DIR/wiki/index.md"; do
    [ -f "$page" ] && grep -oh '\[\[[^]]*\]\]' "$page" 2>/dev/null
done | sed 's/\[\[//;s/\]\]//;s/|.*//' | sort -u)

for link in $links; do
    if ! echo "$wiki_files" | grep -q "$(basename "$link")\.md$"; then
        echo "- [[$link]] (目标文件不存在)" >> "$REPORT_FILE"
        broken_count=$((broken_count + 1))
    fi
done
[ "$broken_count" -eq 0 ] && echo "- 无断裂链接" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 3. 过时内容检测
echo "## 3. 过时内容 (Stale Pages > 30 days)" >> "$REPORT_FILE"
stale_count=0
today=$(date +%s)
for page in $wiki_files; do
    [ -f "$page" ] || continue
    updated=$(grep '^updated:' "$page" 2>/dev/null | head -1 | awk '{print $2}')
    [ -z "$updated" ] && continue
    updated_ts=$(date -d "$updated" +%s 2>/dev/null || echo 0)
    [ "$updated_ts" -eq 0 ] && continue
    days=$(( (today - updated_ts) / 86400 ))
    if [ "$days" -gt 30 ]; then
        slug=$(basename "$page" .md)
        echo "- $slug (已 $days 天未更新)" >> "$REPORT_FILE"
        stale_count=$((stale_count + 1))
    fi
done
[ "$stale_count" -eq 0 ] && echo "- 无过时页面" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 4. 未消化的源文档检测
echo "## 4. 未消化的源文档 (Unprocessed Sources)" >> "$REPORT_FILE"
unprocessed=0
for src in $(find "$KB_DIR" -path "*/raw/*" -name "*.md" -type f 2>/dev/null); do
    src_slug=$(basename "$src" .md)
    if ! echo "$wiki_files" | xargs grep -l "$src_slug" 2>/dev/null | grep -q .; then
        echo "- $src (未被任何 wiki 页面引用)" >> "$REPORT_FILE"
        unprocessed=$((unprocessed + 1))
    fi
done
[ "$unprocessed" -eq 0 ] && echo "- 所有源文档已处理" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 5. 索引膨胀检查
echo "## 5. 索引膨胀 (Index Bloat)" >> "$REPORT_FILE"
for idx in $(find "$KB_DIR" -name "index.md" -not -path "*/search/*" 2>/dev/null); do
    index_count=$(grep -c '^\- \[\[' "$idx" 2>/dev/null || echo 0)
    echo "- $idx: $index_count 条目" >> "$REPORT_FILE"
    if [ "$index_count" -gt 50 ]; then
        echo "  - ⚠️  索引膨胀警告（> 50 条目）" >> "$REPORT_FILE"
    else
        echo "  - 正常 (< 50 条目)" >> "$REPORT_FILE"
    fi
done
echo "" >> "$REPORT_FILE"

# 6. 矛盾检测
echo "## 6. 矛盾检测 (Contradiction Detection)" >> "$REPORT_FILE"
echo "- 此项需要 AI 语义分析，请在 \`wiki lint\` 中由 Claude Code 执行" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 7. raw 版本膨胀检查
echo "## 7. Raw 版本膨胀检查" >> "$REPORT_FILE"
raw_count=0
for archive_dir in $(find "$KB_DIR" -path "*/raw/notes/archive" -type d 2>/dev/null); do
    count=$(find "$archive_dir" -name "*.md" 2>/dev/null | wc -l)
    count=$(echo "$count" | tr -d ' ')
    if [ "$count" -gt 3 ]; then
        echo "- ⚠️  $archive_dir 有 $count 个版本（上限 3 个），建议清理最旧的" >> "$REPORT_FILE"
        raw_count=$((raw_count + 1))
    fi
done
[ "$raw_count" -eq 0 ] && echo "- 所有项目 raw 版本正常（archive/ 上限 3 个）" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# 摘要
echo "---" >> "$REPORT_FILE"
total_pages=$(echo "$wiki_files" | grep -c . 2>/dev/null || echo 0)
echo "**摘要**: 共 $total_pages 个 wiki 页面，$orphan_count 个孤立页面，$stale_count 个过时页面" >> "$REPORT_FILE"

echo ""
echo "=== Wiki 健康检查完成 ==="
echo "报告: $REPORT_FILE"
cat "$REPORT_FILE"

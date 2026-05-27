#!/bin/bash
# LLM Wiki 每周快速检查脚本
# 用法: ./health-check.sh <knowledge-base-path>
# 输出: 生成 lint-report-YYYY-MM-DD.md

KB_PATH="${1:-.}"
REPORT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="${KB_PATH}/wiki/lint-report-${REPORT_DATE}.md"

echo "# Wiki 健康检查报告 - ${REPORT_DATE}" > "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"

# 1. 孤立页面检测
echo "## 1. 孤立页面 (Orphan Pages)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
ORPHANS=()
while IFS= read -r -d '' file; do
  if grep -q "linked_from: \[\]" "$file" 2>/dev/null; then
    # 检查是否只有空列表或完全无 linked_from 字段
    if ! grep -q "linked_from: \[." "$file" 2>/dev/null; then
      ORPHANS+=("$(basename "$file" .md)")
    fi
  fi
done < <(find "${KB_PATH}/wiki" -name "*.md" -not -name "index.md" -not -name "log.md" -print0)

if [ ${#ORPHANS[@]} -eq 0 ]; then
  echo "- 无孤立页面" >> "${REPORT_FILE}"
else
  for page in "${ORPHANS[@]}"; do
    echo "- [孤立] ${page}" >> "${REPORT_FILE}"
  done
fi
echo "" >> "${REPORT_FILE}"

# 2. 断裂链接检测
echo "## 2. 断裂链接 (Broken Links)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
BROKEN=0
while IFS= read -r -d '' file; do
  # 提取 [[wiki-link]] 格式的链接
  grep -oP '\[\[([^\]]+)\]\]' "$file" 2>/dev/null | while read -r link; do
    slug=$(echo "$link" | sed 's/\[\[\(.*\)\]\]/\1/')
    found=0
    while IFS= read -r -d '' target; do
      if [[ "$(basename "$target" .md)" == "$slug" ]]; then
        found=1
        break
      fi
    done < <(find "${KB_PATH}/wiki" -name "*.md" -print0)
    if [ $found -eq 0 ]; then
      echo "- ${file} -> [[${slug}]] (不存在)" >> "${REPORT_FILE}"
      BROKEN=$((BROKEN + 1))
    fi
  done
done < <(find "${KB_PATH}/wiki" -name "*.md" -not -name "index.md" -not -name "log.md" -print0)

if [ $BROKEN -eq 0 ]; then
  echo "- 无断裂链接" >> "${REPORT_FILE}"
fi
echo "" >> "${REPORT_FILE}"

# 3. 过时内容标记
echo "## 3. 过时内容 (Stale Pages)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
STALE=0
while IFS= read -r -d '' file; do
  updated=$(grep "^updated:" "$file" 2>/dev/null | head -1 | awk '{print $2}')
  if [ -n "$updated" ]; then
    # 简单日期比较（仅适用于同一年内）
    if [[ "$updated" < "2026-04-27" ]]; then
      echo "- [待验证] $(basename "$file" .md) (最后更新: ${updated})" >> "${REPORT_FILE}"
      STALE=$((STALE + 1))
    fi
  fi
done < <(find "${KB_PATH}/wiki" -name "*.md" -not -name "index.md" -not -name "log.md" -print0)

if [ $STALE -eq 0 ]; then
  echo "- 无过时页面" >> "${REPORT_FILE}"
fi
echo "" >> "${REPORT_FILE}"

# 4. 覆盖率缺口
echo "## 4. 未消化的源文档 (Unprocessed Sources)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
UNPROCESSED=0
while IFS= read -r -d '' source_file; do
  # 检查 log.md 是否提及此文件
  if ! grep -q "$(basename "$source_file")" "${KB_PATH}/wiki/log.md" 2>/dev/null; then
    echo "- ${source_file}" >> "${REPORT_FILE}"
    UNPROCESSED=$((UNPROCESSED + 1))
  fi
done < <(find "${KB_PATH}/raw" -type f -name "*.md" -print0)

if [ $UNPROCESSED -eq 0 ]; then
  echo "- 所有源文档已处理" >> "${REPORT_FILE}"
fi
echo "" >> "${REPORT_FILE}"

# 5. 索引膨胀检查
echo "## 5. 索引膨胀 (Index Bloat)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
INDEX_ENTRIES=$(grep -c "^- \[\[" "${KB_PATH}/wiki/index.md" 2>/dev/null || echo "0")
echo "- index.md 当前条目数: ${INDEX_ENTRIES}" >> "${REPORT_FILE}"
if [ $INDEX_ENTRIES -gt 50 ]; then
  echo "- **警告**: 超过 50 条目阈值，建议启用 grep 搜索辅助" >> "${REPORT_FILE}"
else
  echo "- 正常 (< 50 条目)" >> "${REPORT_FILE}"
fi
echo "" >> "${REPORT_FILE}"

# 6. 矛盾检测提示
echo "## 6. 矛盾检测 (Contradiction Detection)" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
echo "- 此项需要 AI 语义分析，请在 \`wiki lint\` 中由 Claude Code 执行" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"

# 统计摘要
TOTAL_PAGES=$(find "${KB_PATH}/wiki" -name "*.md" -not -name "index.md" -not -name "log.md" | wc -l)
echo "---" >> "${REPORT_FILE}"
echo "" >> "${REPORT_FILE}"
echo "**摘要**: 共 ${TOTAL_PAGES} 个 wiki 页面，${#ORPHANS[@]} 个孤立页面，${STALE} 个过时页面，${UNPROCESSED} 个未消化源文档" >> "${REPORT_FILE}"

echo "报告已生成: ${REPORT_FILE}"
cat "${REPORT_FILE}"

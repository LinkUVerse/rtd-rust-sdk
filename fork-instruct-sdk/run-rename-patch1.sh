#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "========================================"
echo "RTD-Rust-SDK 补丁脚本 (Patch 1)"
echo "修复遗漏的文件重命名"
echo "========================================"

# 重命名 .fds.bin 文件
echo "重命名 .fds.bin 文件..."

find . -name "sui.*.fds.bin" ! -path "./.git/*" ! -path "./target/*" 2>/dev/null | while read -r file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    new_base="${base/sui./rtd.}"
    if [ "$base" != "$new_base" ]; then
        echo "  $file -> $dir/$new_base"
        mv "$file" "$dir/$new_base"
    fi
done

# 检查是否还有其他 sui 开头的文件
echo ""
echo "检查是否还有遗漏的 sui* 文件..."
remaining=$(find . -name "sui*" ! -path "./.git/*" ! -path "./target/*" -type f 2>/dev/null | wc -l)

if [ "$remaining" -gt 0 ]; then
    echo "警告: 还有 $remaining 个文件未处理:"
    find . -name "sui*" ! -path "./.git/*" ! -path "./target/*" -type f 2>/dev/null
else
    echo "所有文件已处理完成!"
fi

echo "========================================"
echo "补丁脚本执行完成！"
echo "========================================"

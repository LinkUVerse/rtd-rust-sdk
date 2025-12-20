#!/bin/bash
set -e

# 修复 macOS sed 的 "illegal byte sequence" 错误
export LC_ALL=C
export LANG=C

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "========================================"
echo "RTD-Rust-SDK 品牌重命名自动化脚本"
echo "========================================"

# Phase 0: 准备
echo "Phase 0: 创建工作分支..."
git checkout -b feature/rtd-brand-rename 2>/dev/null || git checkout feature/rtd-brand-rename

# Phase 1: 文件内容替换
echo "Phase 1: 执行文件内容替换..."

# 1. 替换 MystenLabs (最长的先替换)
echo "  替换 MystenLabs -> LinkUVerse..."
find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) \
    ! -path "./.git/*" ! -path "./target/*" \
    -exec sed -i '' 's/MystenLabs/LinkUVerse/g' {} \; 2>/dev/null || true

# 2. 替换 Mysten (首字母大写)
echo "  替换 Mysten -> LinkU..."
find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) \
    ! -path "./.git/*" ! -path "./target/*" \
    -exec sed -i '' 's/Mysten/LinkU/g' {} \; 2>/dev/null || true

# 3. 替换 mysten (小写)
echo "  替换 mysten -> linku..."
find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) \
    ! -path "./.git/*" ! -path "./target/*" \
    -exec sed -i '' 's/mysten/linku/g' {} \; 2>/dev/null || true

# 4. 替换 SUI (大写)
echo "  替换 SUI -> RTD..."
find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) \
    ! -path "./.git/*" ! -path "./target/*" \
    -exec sed -i '' 's/SUI/RTD/g' {} \; 2>/dev/null || true

# 5. 替换 Sui (混合大小写)
echo "  替换 Sui -> RTD..."
find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) \
    ! -path "./.git/*" ! -path "./target/*" \
    -exec sed -i '' 's/Sui/Rtd/g' {} \; 2>/dev/null || true

# 6. 替换 sui (小写)
echo "  替换 sui -> rtd..."
find . -type f \( -name "*.rs" -o -name "*.toml" -o -name "*.md" -o -name "*.yaml" -o -name "*.yml" -o -name "*.json" -o -name "*.proto" \) \
    ! -path "./.git/*" ! -path "./target/*" \
    -exec sed -i '' 's/sui/rtd/g' {} \; 2>/dev/null || true

# Phase 2: 重命名目录
echo "Phase 2: 重命名目录..."

# 重命名 crates 下的目录
echo "  重命名 crates/sui-* -> crates/rtd-*..."
for dir in crates/sui-*; do
    if [ -d "$dir" ]; then
        new_dir="${dir/sui-/rtd-}"
        echo "    $dir -> $new_dir"
        mv "$dir" "$new_dir"
    fi
done

# 重命名 proto 子目录（使用更安全的方式）
echo "  重命名 proto/sui -> proto/rtd..."
find . -type d -name "sui" ! -path "./.git/*" ! -path "./target/*" 2>/dev/null | while read -r sui_dir; do
    # 检查是否在 proto 路径下
    if echo "$sui_dir" | grep -q "proto"; then
        parent_dir=$(dirname "$sui_dir")
        new_dir="$parent_dir/rtd"
        if [ -d "$sui_dir" ] && [ ! -d "$new_dir" ]; then
            echo "    $sui_dir -> $new_dir"
            mv "$sui_dir" "$new_dir"
        fi
    fi
done

# Phase 3: 重命名文件
echo "Phase 3: 重命名文件..."

# 重命名 sui 相关文件名
find . -name "sui*.rs" ! -path "./.git/*" ! -path "./target/*" 2>/dev/null | while read -r file; do
    dir=$(dirname "$file")
    base=$(basename "$file")
    new_base="${base/sui/rtd}"
    if [ "$base" != "$new_base" ]; then
        echo "    $file -> $dir/$new_base"
        mv "$file" "$dir/$new_base"
    fi
done

# Phase 4: 清理 target 目录
echo "Phase 4: 清理 target 目录..."
rm -rf target

echo "========================================"
echo "替换完成！"
echo ""
echo "后续步骤："
echo "1. 运行 cargo build 验证"
echo "2. 提交更改: git add -A && git commit -m 'Brand rename: Sui -> RTD'"
echo "3. 推送到远程: git push origin feature/rtd-brand-rename"
echo "========================================"

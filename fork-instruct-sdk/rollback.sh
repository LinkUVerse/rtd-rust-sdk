#!/bin/bash

# 回退脚本：删除工作分支，回到 main 分支
# 注意：保留 fork-instruct 目录

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo "========================================"
echo "执行回退操作"
echo "========================================"

# 先保存 fork-instruct 目录到临时位置
echo "备份 fork-instruct 目录..."
TEMP_DIR=$(mktemp -d)
cp -r "$SCRIPT_DIR" "$TEMP_DIR/"

# 放弃所有未提交的更改
echo "放弃所有未提交的更改..."
git reset --hard HEAD
git clean -fd

# 切换到 main 分支
echo "切换到 main 分支..."
git checkout main

# 删除工作分支（如果存在）
if git show-ref --verify --quiet refs/heads/feature/rtd-brand-rename; then
    echo "删除 feature/rtd-brand-rename 分支..."
    git branch -D feature/rtd-brand-rename
fi

# 恢复 fork-instruct 目录
echo "恢复 fork-instruct 目录..."
rm -rf "$SCRIPT_DIR"
cp -r "$TEMP_DIR/fork-instruct" "$PROJECT_ROOT/"
rm -rf "$TEMP_DIR"

echo "========================================"
echo "回退完成！当前在 main 分支"
echo "fork-instruct 目录已保留"
echo "可以修改脚本后重新执行"
echo "========================================"

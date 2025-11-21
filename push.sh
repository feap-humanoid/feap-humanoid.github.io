#!/bin/bash

# 脚本：强制推送到 GitHub 仓库
# 用途：添加、提交并强制推送到 master 分支

set -e  # 遇到错误立即退出

REPO_URL="git@github.com:feap-humanoid/feap-humanoid.github.io.git"
BRANCH="master"

echo "=========================================="
echo "开始推送到 GitHub 仓库"
echo "仓库: $REPO_URL"
echo "分支: $BRANCH"
echo "=========================================="

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "错误: 当前目录不是 git 仓库"
    exit 1
fi

# 检查远程仓库配置
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "配置远程仓库..."
    git remote add origin $REPO_URL
else
    echo "更新远程仓库 URL..."
    git remote set-url origin $REPO_URL
fi

# 显示当前状态
echo ""
echo "当前 git 状态:"
git status

# 添加所有更改
echo ""
echo "添加所有更改..."
git add .

# 检查是否有更改需要提交
if git diff --cached --quiet; then
    echo "没有更改需要提交"
else
    # 提交更改
    echo ""
    echo "提交更改..."
    COMMIT_MSG="Update: $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$COMMIT_MSG" || {
        echo "提交失败，尝试使用默认提交信息..."
        git commit -m "Update files"
    }
fi

# 强制推送到 master 分支
echo ""
echo "强制推送到 $BRANCH 分支..."
echo "警告: 这将覆盖远程 $BRANCH 分支的所有更改！"
git push -f origin $BRANCH

echo ""
echo "=========================================="
echo "推送完成！"
echo "=========================================="


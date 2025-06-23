#!/bin/bash

# 智能 Git 自动提交并推送脚本
# 用法：bash git_smart_push.sh "你的提交说明"

# 检查是否为 Git 仓库
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo -e "\033[31m✖ Error: Not a Git repository.\033[0m"
    exit 1
fi

# 读取提交信息
if [ -z "$1" ]; then
    echo -e "\033[33m⚠ Warning: No commit message provided.\033[0m"
    read -p "Please enter commit message: " COMMIT_MSG
    if [ -z "$COMMIT_MSG" ]; then
        echo -e "\033[31m✖ Commit message cannot be empty.\033[0m"
        exit 2
    fi
else
    COMMIT_MSG="$1"
fi

# 检查是否有变更（包括 staged / unstaged）
if git diff --cached --quiet && git diff --quiet; then
    echo -e "\033[36mℹ No changes to commit. Working directory clean.\033[0m"
    exit 0
fi

# 获取当前分支名
BRANCH=$(git symbolic-ref --short HEAD)

# 添加所有修改
git add .

# 提交更改
git commit -m "$COMMIT_MSG"

# 拉取远程分支（避免推送冲突）
git pull --rebase origin "$BRANCH"

# 推送当前分支
git push origin "$BRANCH"

# 最终提示
if [ $? -eq 0 ]; then
    echo -e "\033[32m✔ Git push to '$BRANCH' completed successfully.\033[0m"
else
    echo -e "\033[31m✖ Git push to '$BRANCH' failed.\033[0m"
fi


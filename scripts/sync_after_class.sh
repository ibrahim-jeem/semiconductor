#!/usr/bin/env bash
set -euo pipefail

PERSONAL="$HOME/semiconductor"
INSTRUCTOR="$HOME/Configuration"
SNAPSHOT="$PERSONAL/class_work/Configuration"

echo "=== Starting class synchronization ==="

# Verify both Git repositories
git -C "$PERSONAL" rev-parse --is-inside-work-tree >/dev/null
git -C "$INSTRUCTOR" rev-parse --is-inside-work-tree >/dev/null

# Only synchronize instructor files from a clean checkout
if [[ -n "$(git -C "$INSTRUCTOR" status --porcelain)" ]]; then
    echo "ERROR: Instructor Configuration has local changes."
    echo "Resolve them before synchronizing."
    exit 1
fi

# Get the instructor's latest updates
echo "Pulling instructor updates..."
git -C "$INSTRUCTOR" pull --ff-only

# Mirror instructor files into your personal repository
echo "Updating Configuration snapshot..."
mkdir -p "$SNAPSHOT"

rsync -a --delete \
    --exclude='.git/' \
    "$INSTRUCTOR/" "$SNAPSHOT/"

# Never copy the instructor's exposed GitHub token into your repository
for file in Git_cloning.txt Git_pulling.txt; do
    if [[ -f "$SNAPSHOT/$file" ]]; then
        sed -E -i \
          's/(github_pat_|ghp_)[A-Za-z0-9_]+/[REDACTED_GITHUB_TOKEN]/g' \
          "$SNAPSHOT/$file"
    fi
done

cd "$PERSONAL"

# Stage all personal class work and configuration updates
git rm --cached --ignore-unmatch -- ':(glob)**/xrun.key' >/dev/null 2>&1 || true
git add -A

# Nothing changed? No need to create a commit
if git diff --cached --quiet; then
    echo "No changes to upload."
    exit 0
fi

# Prevent accidental credential uploads
if ! git diff --cached -G '(github_pat_|ghp_)' --quiet; then
    echo "ERROR: Possible GitHub token detected in staged changes."
    echo "Nothing committed or pushed. Inspect the staged changes."
    exit 1
fi

if git diff --cached --name-only | grep -Eq '(^|/)xrun\.key$'; then
    echo "ERROR: xrun.key detected. Nothing pushed."
    exit 1
fi

git diff --cached --check

# Commit and upload
git commit -m "Update class work and configuration $(date +%F)"
git push origin main

echo "=== Synchronization completed successfully ==="

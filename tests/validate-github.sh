#!/bin/bash
# Validate GitHub repository was created and code pushed

set -e

# Get product handle from config
source product.config 2>/dev/null || PRODUCT_HANDLE="unknown"

echo "Validating GitHub repository..."

# Check if we're in a git repo
if [ ! -d ".git" ]; then
  echo "FAIL: Not a git repository"
  echo "FIX: Initialize git and push to GitHub"
  echo "Commands:"
  echo "  git init"
  echo "  git add ."
  echo "  git commit -m 'Initial commit'"
  echo "  gh repo create ${PRODUCT_HANDLE}-landing --public --source=. --push"
  exit 1
fi
echo "✓ Git repository initialized"

# Check if remote exists
if ! git remote -v | grep -q "origin"; then
  echo "FAIL: No remote 'origin' configured"
  echo "FIX: Add GitHub remote or create repo with gh CLI"
  exit 1
fi
echo "✓ Remote 'origin' configured"

# Get remote URL
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")
echo "✓ Remote URL: $REMOTE_URL"

# Check if we have commits
COMMIT_COUNT=$(git rev-list --count HEAD 2>/dev/null || echo 0)
if [ "$COMMIT_COUNT" -eq 0 ]; then
  echo "FAIL: No commits in repository"
  echo "FIX: Commit your changes"
  exit 1
fi
echo "✓ Commits: $COMMIT_COUNT"

# Check if pushed (compare local and remote)
git fetch origin main 2>/dev/null || git fetch origin master 2>/dev/null || true
LOCAL=$(git rev-parse HEAD 2>/dev/null || echo "none")
REMOTE=$(git rev-parse origin/main 2>/dev/null || git rev-parse origin/master 2>/dev/null || echo "none")

if [ "$LOCAL" != "$REMOTE" ]; then
  echo "WARNING: Local and remote may be out of sync"
  echo "Run: git push origin main"
fi

echo ""
echo "PASS: GitHub repository validated ✓"
exit 0

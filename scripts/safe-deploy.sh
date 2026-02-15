#!/bin/bash
# safe-deploy.sh
# Safely deploys to GitHub and Netlify without overwriting existing projects

set -e

# Get product handle from product.config or argument
PRODUCT_HANDLE="${1:-$(grep 'PRODUCT_HANDLE=' product.config 2>/dev/null | cut -d'=' -f2 | tr -d '"' | tr -d "'" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')}"
POOL_URL="${2:-https://simpleswap-pool.onrender.com}"

if [[ -z "$PRODUCT_HANDLE" ]]; then
    echo "❌ ERROR: No product handle provided"
    echo "Usage: ./safe-deploy.sh <product-handle> [pool-url]"
    exit 1
fi

echo "======================================"
echo "  SAFE DEPLOY: $PRODUCT_HANDLE"
echo "======================================"

# ============================================
# STEP 1: Check GitHub CLI is authenticated
# ============================================
echo ""
echo "📦 Checking GitHub CLI..."
if ! gh auth status &>/dev/null; then
    echo "❌ GitHub CLI not authenticated"
    echo "Run: gh auth login"
    exit 1
fi
echo "✅ GitHub CLI authenticated"

# ============================================
# STEP 2: Check Netlify CLI is authenticated
# ============================================
echo ""
echo "🌐 Checking Netlify CLI..."
if ! netlify status &>/dev/null; then
    echo "❌ Netlify CLI not authenticated"
    echo "Run: netlify login"
    exit 1
fi
echo "✅ Netlify CLI authenticated"

# ============================================
# STEP 3: Check if GitHub repo exists
# ============================================
echo ""
echo "📦 Checking if GitHub repo exists..."
REPO_NAME="${PRODUCT_HANDLE}-landing"

if gh repo view "$REPO_NAME" --json name &>/dev/null; then
    echo "⚠️  Repository '$REPO_NAME' already exists!"
    echo ""
    echo "Options:"
    echo "  1) Update existing repo (push changes)"
    echo "  2) Create new repo with suffix (e.g., ${REPO_NAME}-v2)"
    echo "  3) Abort"
    echo ""
    read -p "Choose [1/2/3]: " GITHUB_CHOICE

    case $GITHUB_CHOICE in
        1)
            GITHUB_ACTION="update"
            ;;
        2)
            read -p "Enter new repo name: " REPO_NAME
            GITHUB_ACTION="create"
            ;;
        *)
            echo "❌ Aborted by user"
            exit 0
            ;;
    esac
else
    echo "✅ Repository '$REPO_NAME' is available"
    GITHUB_ACTION="create"
fi

# ============================================
# STEP 4: Check if Netlify site exists
# ============================================
echo ""
echo "🌐 Checking if Netlify site exists..."
SITE_NAME="$PRODUCT_HANDLE"

if netlify sites:list --json 2>/dev/null | grep -q "\"name\":.*\"$SITE_NAME\""; then
    echo "⚠️  Netlify site '$SITE_NAME' already exists!"
    echo ""
    echo "Options:"
    echo "  1) Deploy to existing site"
    echo "  2) Create new site with suffix (e.g., ${SITE_NAME}-v2)"
    echo "  3) Abort"
    echo ""
    read -p "Choose [1/2/3]: " NETLIFY_CHOICE

    case $NETLIFY_CHOICE in
        1)
            NETLIFY_ACTION="update"
            ;;
        2)
            read -p "Enter new site name: " SITE_NAME
            NETLIFY_ACTION="create"
            ;;
        *)
            echo "❌ Aborted by user"
            exit 0
            ;;
    esac
else
    echo "✅ Netlify site '$SITE_NAME' is available"
    NETLIFY_ACTION="create"
fi

# ============================================
# STEP 5: Deploy to GitHub
# ============================================
echo ""
echo "📦 Deploying to GitHub..."

# Initialize git if needed
if [[ ! -d ".git" ]]; then
    git init
    git branch -M main
fi

# Add and commit
git add .
git commit -m "Deploy: $PRODUCT_HANDLE landing page" 2>/dev/null || echo "No changes to commit"

if [[ "$GITHUB_ACTION" == "create" ]]; then
    # Create new repo and push
    gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
else
    # Push to existing repo
    git push origin main
fi

GITHUB_URL=$(gh repo view "$REPO_NAME" --json url -q '.url')
echo "✅ GitHub: $GITHUB_URL"

# ============================================
# STEP 6: Deploy to Netlify
# ============================================
echo ""
echo "🌐 Deploying to Netlify..."

if [[ "$NETLIFY_ACTION" == "create" ]]; then
    # Create new site
    netlify sites:create --name "$SITE_NAME"
fi

# Link and set environment
netlify link --name "$SITE_NAME" 2>/dev/null || true
netlify env:set POOL_URL "$POOL_URL"

# Deploy
DEPLOY_OUTPUT=$(netlify deploy --prod --dir=. 2>&1)
LIVE_URL=$(echo "$DEPLOY_OUTPUT" | grep -o 'https://[^[:space:]]*\.netlify\.app' | head -1)

if [[ -z "$LIVE_URL" ]]; then
    LIVE_URL="https://${SITE_NAME}.netlify.app"
fi

echo "✅ Netlify: $LIVE_URL"

# ============================================
# STEP 7: Verify deployment
# ============================================
echo ""
echo "🔍 Verifying deployment..."

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$LIVE_URL")

if [[ "$HTTP_STATUS" == "200" ]]; then
    echo "✅ Site returns 200 OK"
else
    echo "⚠️  Site returned HTTP $HTTP_STATUS"
fi

# ============================================
# SUMMARY
# ============================================
echo ""
echo "======================================"
echo "  ✅ DEPLOYMENT COMPLETE"
echo "======================================"
echo ""
echo "📦 GitHub:  $GITHUB_URL"
echo "🌐 Live:    $LIVE_URL"
echo ""
echo "Next: Run browser tests with:"
echo "  bash tests/run-all-browser-tests.sh $LIVE_URL"
echo ""

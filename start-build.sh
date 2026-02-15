#!/bin/bash
# =============================================================================
# START-BUILD.SH - One command to build a complete landing page
# =============================================================================
#
# Usage:
#   ./start-build.sh "Product Name" "https://competitor-url.com" [options]
#
# Options:
#   --model MODEL      Specify Claude model (sonnet, opus, haiku)
#   --zai              Use GLM 4.7 via z.ai (sources setup-zai.sh)
#   --opencode         Use OpenCode engine instead of Claude
#   --qwen             Use Qwen engine
#
# Examples:
#   ./start-build.sh "Sample Product" "https://competitor.com"
#   ./start-build.sh "Sample Product" "https://competitor.com" --haiku
#   ./start-build.sh "Sample Product" "https://competitor.com" --zai
#
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# -----------------------------------------------------------------------------
# STEP 1: Parse arguments
# -----------------------------------------------------------------------------

PRODUCT=""
COMPETITOR=""
RALPHY_ARGS=""
USE_ZAI=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --model)
      RALPHY_ARGS="$RALPHY_ARGS --model $2"
      shift 2
      ;;
    --opencode)
      RALPHY_ARGS="$RALPHY_ARGS --opencode"
      shift
      ;;
    --qwen)
      RALPHY_ARGS="$RALPHY_ARGS --qwen"
      shift
      ;;
    --sonnet)
      RALPHY_ARGS="$RALPHY_ARGS --model sonnet"
      shift
      ;;
    --haiku)
      RALPHY_ARGS="$RALPHY_ARGS --model haiku"
      shift
      ;;
    --opus)
      RALPHY_ARGS="$RALPHY_ARGS --model opus"
      shift
      ;;
    --zai|--glm|--claude-yolo)
      USE_ZAI=true
      shift
      ;;
    *)
      # Positional arguments
      if [ -z "$PRODUCT" ]; then
        PRODUCT="$1"
      elif [ -z "$COMPETITOR" ]; then
        COMPETITOR="$1"
      fi
      shift
      ;;
  esac
done

if [ -z "$PRODUCT" ]; then
  echo -e "${RED}ERROR: Product name required${NC}"
  echo ""
  echo "Usage: ./start-build.sh \"Product Name\" \"https://competitor-url.com\" [options]"
  echo ""
  echo "Options:"
  echo "  --model MODEL    Specify Claude model (sonnet, opus, haiku)"
  echo "  --sonnet         Use Claude Sonnet"
  echo "  --haiku          Use Claude Haiku"
  echo "  --opus           Use Claude Opus"
  echo "  --zai            Use GLM 4.7 via z.ai backend"
  echo "  --opencode       Use OpenCode engine"
  echo "  --qwen           Use Qwen engine"
  echo ""
  echo "Examples:"
  echo "  ./start-build.sh \"Sample Product\" \"https://competitor.com\""
  echo "  ./start-build.sh \"Sample Product\" \"https://competitor.com\" --haiku"
  echo "  ./start-build.sh \"Sample Product\" \"https://competitor.com\" --zai"
  exit 1
fi

if [ -z "$COMPETITOR" ]; then
  echo -e "${YELLOW}WARNING: No competitor URL provided. Research will be limited.${NC}"
  COMPETITOR="[NO COMPETITOR URL PROVIDED]"
fi

echo -e "${BLUE}=============================================${NC}"
echo -e "${BLUE}  BRUNSON LANDING PAGE BUILDER${NC}"
echo -e "${BLUE}=============================================${NC}"
echo ""
echo -e "Product:    ${GREEN}$PRODUCT${NC}"
echo -e "Competitor: ${GREEN}$COMPETITOR${NC}"
echo -e "Date:       ${GREEN}$(date +%Y-%m-%d)${NC}"
if [ "$USE_ZAI" = true ]; then
  echo -e "Model:      ${GREEN}GLM 4.7 (z.ai)${NC}"
elif [ -n "$RALPHY_ARGS" ]; then
  echo -e "Options:    ${GREEN}$RALPHY_ARGS${NC}"
fi
echo ""

# -----------------------------------------------------------------------------
# STEP 2: Check prerequisites
# -----------------------------------------------------------------------------

echo -e "${YELLOW}Checking prerequisites...${NC}"

# Check Ralphy
if ! command -v ralphy &> /dev/null; then
  echo -e "${RED}ERROR: Ralphy not installed${NC}"
  echo ""
  echo "Install Ralphy:"
  echo "  npm install -g ralphy-cli"
  echo ""
  echo "Or clone and link:"
  echo "  git clone https://github.com/michaelshimeles/ralphy.git"
  echo "  cd ralphy && npm install && npm link"
  exit 1
fi
echo -e "  ✓ Ralphy installed"

# Check Netlify CLI
if ! command -v netlify &> /dev/null; then
  echo -e "${RED}ERROR: Netlify CLI not installed${NC}"
  echo "  npm install -g netlify-cli"
  exit 1
fi
echo -e "  ✓ Netlify CLI installed"

# Check images
PRODUCT_IMAGES=$(ls -1 images/product/ 2>/dev/null | wc -l | tr -d ' ')
TESTIMONIAL_IMAGES=$(ls -1 images/testimonials/ 2>/dev/null | wc -l | tr -d ' ')

if [ "$PRODUCT_IMAGES" -lt 5 ]; then
  echo -e "${RED}ERROR: Need at least 5 product images in images/product/${NC}"
  echo "  Found: $PRODUCT_IMAGES"
  exit 1
fi
echo -e "  ✓ Product images: $PRODUCT_IMAGES"

if [ "$TESTIMONIAL_IMAGES" -lt 12 ]; then
  echo -e "${RED}ERROR: Need at least 12 testimonial images in images/testimonials/${NC}"
  echo "  Found: $TESTIMONIAL_IMAGES"
  exit 1
fi
echo -e "  ✓ Testimonial images: $TESTIMONIAL_IMAGES"

# Check PRD.md exists
if [ ! -f "PRD.md" ]; then
  echo -e "${RED}ERROR: PRD.md not found${NC}"
  exit 1
fi
echo -e "  ✓ PRD.md exists"

echo ""

# -----------------------------------------------------------------------------
# STEP 3: Update PRD.md
# -----------------------------------------------------------------------------

echo -e "${YELLOW}Updating PRD.md...${NC}"

# Backup current PRD
cp PRD.md PRD.md.backup-$(date +%Y%m%d-%H%M%S)

# Update product details (macOS compatible sed)
sed -i '' "s|> \*\*Product:\*\* .*|> **Product:** $PRODUCT|" PRD.md
sed -i '' "s|> \*\*Competitor:\*\* .*|> **Competitor:** $COMPETITOR|" PRD.md
sed -i '' "s|> \*\*Started:\*\* .*|> **Started:** $(date +%Y-%m-%d)|" PRD.md

# Reset all checkboxes to unchecked
sed -i '' 's/- \[x\]/- [ ]/g' PRD.md

echo -e "  ✓ PRD.md updated"
echo ""

# -----------------------------------------------------------------------------
# STEP 4: Clear previous build artifacts
# -----------------------------------------------------------------------------

echo -e "${YELLOW}Clearing previous build artifacts...${NC}"

# Backup context if exists
if [ -d "context" ] && [ "$(ls -A context 2>/dev/null)" ]; then
  mkdir -p context-backups
  mv context context-backups/context-$(date +%Y%m%d-%H%M%S)
  mkdir -p context
  echo -e "  ✓ Previous context backed up and cleared"
else
  mkdir -p context
  echo -e "  ✓ Context directory ready"
fi

echo ""

# -----------------------------------------------------------------------------
# STEP 5: Setup z.ai environment (if using GLM)
# -----------------------------------------------------------------------------

if [ "$USE_ZAI" = true ]; then
  echo -e "${YELLOW}Configuring z.ai for GLM 4.7...${NC}"

  # Check if setup script exists
  ZAI_SETUP="$HOME/zaiinstall/setup-zai.sh"
  if [ ! -f "$ZAI_SETUP" ]; then
    echo -e "${RED}ERROR: z.ai setup not found at $ZAI_SETUP${NC}"
    echo -e "Install z.ai DevPack first or check the path"
    exit 1
  fi

  # Source the z.ai setup (sets ANTHROPIC_BASE_URL, ANTHROPIC_AUTH_TOKEN, ANTHROPIC_MODEL)
  source "$ZAI_SETUP"
  echo -e "  ✓ z.ai environment configured (GLM 4.7)"
  echo ""
fi

# -----------------------------------------------------------------------------
# STEP 6: Launch Ralphy
# -----------------------------------------------------------------------------

echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  LAUNCHING RALPHY${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "Ralphy will now execute all tasks in PRD.md"
echo -e "Each task will be verified before marking complete"
if [ "$USE_ZAI" = true ]; then
  echo -e "Backend: ${GREEN}z.ai (GLM 4.7)${NC}"
fi
echo ""
echo -e "${YELLOW}Starting in 3 seconds... (Ctrl+C to cancel)${NC}"
sleep 3
echo ""

# Run Ralphy with any additional args
ralphy $RALPHY_ARGS

# -----------------------------------------------------------------------------
# STEP 7: Done
# -----------------------------------------------------------------------------

echo ""
echo -e "${GREEN}=============================================${NC}"
echo -e "${GREEN}  BUILD COMPLETE${NC}"
echo -e "${GREEN}=============================================${NC}"
echo ""
echo -e "Check PRD.md for task completion status"
echo -e "Check context/ for generated files"
echo -e "Check index.html for built page"
echo ""

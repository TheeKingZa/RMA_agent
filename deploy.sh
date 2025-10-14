#!/bin/bash
# =======================================================
# deploy.sh — Deploys site by syncing gh-pages with master
# Author: Pule Mathikha
# =======================================================

# ---------- COLOR CODES ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # reset color

REPO_URL="https://github.com/TheeKingZa/RMA_agent.git"
LIVE_URL="https://theekingza.github.io/RMA_agent/"

# ---------- STEP 1: VERIFY GIT REPO ----------
if [ ! -d ".git" ]; then
  echo -e "${RED}❌ This is not a Git repository. Run 'git init' first.${NC}"
  exit 1
fi

# ---------- STEP 2: SHOW STATUS ----------
echo -e "${BLUE}🔍 Checking repository status...${NC}"
git status -s

# ---------- STEP 3: ADD & COMMIT CHANGES ----------
echo -e "${YELLOW}✏️  Preparing to commit your latest changes...${NC}"
git add .

# Ask for a custom commit message
read -p "📝 Enter commit message: " COMMIT_MSG

# If message empty, set default
if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="Auto-deploy update on $(date '+%Y-%m-%d %H:%M:%S')"
fi

git commit -m "$COMMIT_MSG" >/dev/null 2>&1 || echo -e "${YELLOW}⚠️  No new changes to commit.${NC}"

# ---------- STEP 4: ENSURE MASTER BRANCH EXISTS ----------
if ! git show-ref --quiet refs/heads/master; then
  echo -e "${YELLOW}⚙️  Creating 'master' branch...${NC}"
  git branch -M master
fi

# ---------- STEP 5: PUSH MASTER (FORCE) ----------
echo -e "${BLUE}⬆️  Pushing master branch to remote...${NC}"
git push origin master --force >/dev/null 2>&1 || { echo -e "${RED}❌ Failed to push master.${NC}"; exit 1; }
echo -e "${GREEN}✅ Master branch pushed successfully.${NC}"

# ---------- STEP 6: CHECK OR CREATE gh-pages ----------
if git show-ref --quiet refs/heads/gh-pages; then
  echo -e "${GREEN}✅ Found 'gh-pages' branch.${NC}"
else
  echo -e "${YELLOW}⚙️  Creating 'gh-pages' branch...${NC}"
  git branch gh-pages
fi

# ---------- STEP 7: TEMPORARY COPY ----------
TEMP_DIR=$(mktemp -d)
echo -e "${BLUE}📦 Copying project files to temporary folder...${NC}"
rsync -av --exclude='.git' --exclude='node_modules' ./ "$TEMP_DIR" >/dev/null 2>&1

# ---------- STEP 8: SWITCH TO gh-pages ----------
echo -e "${BLUE}🌿 Switching to gh-pages...${NC}"
git checkout gh-pages >/dev/null 2>&1 || { echo -e "${RED}❌ Could not switch to gh-pages.${NC}"; exit 1; }

# ---------- STEP 9: CLEAR OLD FILES SAFELY ----------
echo -e "${YELLOW}🧹 Clearing old gh-pages files (keeping .git)...${NC}"
find . -mindepth 1 ! -regex '^./\.git\(/.*\)?' -delete

# ---------- STEP 10: COPY MASTER FILES ----------
echo -e "${BLUE}📂 Copying new files from master...${NC}"
cp -r "$TEMP_DIR"/* ./

# ---------- STEP 11: COMMIT & PUSH TO gh-pages ----------
echo -e "${BLUE}📝 Committing gh-pages updates...${NC}"
git add .
git commit -m "🚀 Deploy: $COMMIT_MSG" >/dev/null 2>&1 || echo -e "${YELLOW}⚠️  No new gh-pages changes to commit.${NC}"

echo -e "${BLUE}⬆️  Pushing gh-pages branch (force)...${NC}"
git push origin gh-pages --force >/dev/null 2>&1 || { echo -e "${RED}❌ Push to gh-pages failed!${NC}"; exit 1; }

# ---------- STEP 12: CLEANUP ----------
echo -e "${BLUE}🧽 Cleaning up temporary files...${NC}"
rm -rf "$TEMP_DIR"

# ---------- STEP 13: RETURN TO MASTER ----------
echo -e "${BLUE}↩️  Returning to master branch...${NC}"
git checkout master >/dev/null 2>&1

# ---------- STEP 14: DONE ----------
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}🌐 Live site: ${YELLOW}${LIVE_URL}${NC}"
echo -e "${BLUE}📦 Repository: ${YELLOW}${REPO_URL}${NC}"

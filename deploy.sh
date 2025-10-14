#!/bin/bash
# =======================================================
# deploy.sh — Force-sync gh-pages with master branch
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

echo -e "${BLUE}🔍 Checking repository status...${NC}"
git status -s

# ---------- STEP 2: CHECK FOR UNCOMMITTED CHANGES ----------
if ! git diff-index --quiet HEAD --; then
  echo -e "${YELLOW}⚠️  You have uncommitted changes.${NC}"
  echo -e "${BLUE}💾 Committing them automatically...${NC}"
  git add .
  git commit -m "Auto-commit before deploy on $(date '+%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1
  echo -e "${GREEN}✅ Changes committed.${NC}"
fi

# ---------- STEP 3: ENSURE MASTER EXISTS ----------
if ! git show-ref --quiet refs/heads/master; then
  echo -e "${YELLOW}⚙️  Creating 'master' branch...${NC}"
  git branch -M master
fi

# ---------- STEP 4: PUSH MASTER (FORCE) ----------
echo -e "${BLUE}⬆️  Pushing master branch to remote (force)...${NC}"
git push origin master --force >/dev/null 2>&1 || { echo -e "${RED}❌ Failed to push master.${NC}"; exit 1; }
echo -e "${GREEN}✅ Master branch pushed successfully.${NC}"

# ---------- STEP 5: CHECK OR CREATE gh-pages ----------
if git show-ref --quiet refs/heads/gh-pages; then
  echo -e "${GREEN}✅ Found 'gh-pages' branch.${NC}"
else
  echo -e "${YELLOW}⚙️  Creating 'gh-pages' branch...${NC}"
  git branch gh-pages
fi

# ---------- STEP 6: TEMPORARY COPY ----------
TEMP_DIR=$(mktemp -d)
echo -e "${BLUE}📦 Copying project files to temporary folder...${NC}"
rsync -av --exclude='.git' --exclude='node_modules' ./ "$TEMP_DIR" >/dev/null 2>&1

# ---------- STEP 7: SWITCH TO gh-pages ----------
echo -e "${BLUE}🌿 Switching to gh-pages...${NC}"
git checkout gh-pages >/dev/null 2>&1 || { echo -e "${RED}❌ Could not switch to gh-pages.${NC}"; exit 1; }

# ---------- STEP 8: CLEAR OLD FILES (KEEP .git) ----------
echo -e "${YELLOW}🧹 Clearing old gh-pages files (keeping .git)...${NC}"
find . -mindepth 1 ! -regex '^./\.git\(/.*\)?' -delete

# ---------- STEP 9: COPY MASTER FILES ----------
echo -e "${BLUE}📂 Copying files from master branch...${NC}"
cp -r "$TEMP_DIR"/* ./

# ---------- STEP 10: COMMIT & PUSH TO gh-pages ----------
echo -e "${BLUE}📝 Committing gh-pages updates...${NC}"
git add .
git commit -m "🚀 Deploy from master on $(date '+%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1 || echo -e "${YELLOW}⚠️  No new changes to commit.${NC}"

echo -e "${BLUE}⬆️  Pushing gh-pages branch (force)...${NC}"
git push origin gh-pages --force >/dev/null 2>&1 || { echo -e "${RED}❌ Push to gh-pages failed!${NC}"; exit 1; }

# ---------- STEP 11: CLEANUP ----------
echo -e "${BLUE}🧽 Cleaning up...${NC}"
rm -rf "$TEMP_DIR"

# ---------- STEP 12: SWITCH BACK ----------
echo -e "${BLUE}↩️  Returning to master branch...${NC}"
git checkout master >/dev/null 2>&1

# ---------- STEP 13: DONE ----------
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${BLUE}🌐 Live site: ${YELLOW}${LIVE_URL}${NC}"
echo -e "${BLUE}📦 Repository: ${YELLOW}${REPO_URL}${NC}"

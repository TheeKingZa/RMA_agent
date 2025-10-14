#!/bin/bash
# =======================================================
# deploy.sh — Force-deploys local files to gh-pages branch safely
# Author: Pule Mathikha
# =======================================================

# ---------- COLOR CODES ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # reset color

# ---------- STEP 1: VERIFY GIT REPO ----------
if [ ! -d ".git" ]; then
  echo -e "${RED}❌ This is not a Git repository. Run 'git init' first.${NC}"
  exit 1
fi

# Ensure at least one commit exists
if [ -z "$(git log --oneline)" ]; then
  echo -e "${RED}❌ No commits found!${NC}"
  echo -e "${YELLOW}➡ Please run 'git add .' and 'git commit -m \"Initial commit\"' first.${NC}"
  exit 1
fi

echo -e "${BLUE}🔍 Checking branches...${NC}"

# ---------- STEP 2: ENSURE BRANCHES EXIST ----------
if ! git show-ref --quiet refs/heads/master; then
  echo -e "${YELLOW}⚙️  Creating 'master' branch...${NC}"
  git checkout -b master
fi

if ! git show-ref --quiet refs/heads/gh-pages; then
  echo -e "${YELLOW}⚙️  Creating 'gh-pages' branch...${NC}"
  git branch gh-pages
fi

# ---------- STEP 3: TEMP COPY ----------
TEMP_DIR=$(mktemp -d)
echo -e "${BLUE}📦 Copying project files to temporary folder...${NC}"
rsync -av --exclude='.git' --exclude='node_modules' ./ "$TEMP_DIR" >/dev/null 2>&1

# ---------- STEP 4: SWITCH TO gh-pages ----------
echo -e "${BLUE}🌿 Switching to gh-pages...${NC}"
git checkout gh-pages >/dev/null 2>&1 || { echo -e "${RED}❌ Failed to switch to gh-pages.${NC}"; exit 1; }

# ---------- STEP 5: WIPE OLD FILES SAFELY ----------
echo -e "${YELLOW}🧹 Clearing old gh-pages files (keeping .git)...${NC}"
find . -mindepth 1 ! -regex '^./\.git\(/.*\)?' -delete

# ---------- STEP 6: COPY NEW FILES ----------
echo -e "${BLUE}📂 Copying new files from local directory...${NC}"
cp -r "$TEMP_DIR"/* ./

# ---------- STEP 7: COMMIT & PUSH ----------
echo -e "${BLUE}📝 Committing changes...${NC}"
git add .
git commit -m "🚀 Forced deploy from local $(date '+%Y-%m-%d %H:%M:%S')" >/dev/null 2>&1

echo -e "${BLUE}⬆️  Pushing to gh-pages (forced)...${NC}"
git push origin gh-pages --force >/dev/null 2>&1 || { echo -e "${RED}❌ Push failed!${NC}"; exit 1; }

# ---------- STEP 8: CLEANUP ----------
echo -e "${BLUE}🧽 Cleaning up temporary files...${NC}"
rm -rf "$TEMP_DIR"

# ---------- STEP 9: RETURN TO master ----------
echo -e "${BLUE}↩️  Switching back to master...${NC}"
git checkout master >/dev/null 2>&1

echo -e "${GREEN}✅ Deployment complete! gh-pages now exactly matches your local files.${NC}"

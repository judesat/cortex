#!/bin/bash
# Sync story status to Lovable project knowledge
# Usage: ./sync-stories-to-lovable.sh [project_id]

PROJECT_ID="${1:-1c73a3f5-2e1c-473f-9f9c-a0346ae28d09}"
STORIES_DIR="$(cd "$(dirname "$0")/../stories" && pwd)"

echo "🔄 Syncing stories to Lovable project knowledge..."

if [ ! -d "$STORIES_DIR" ]; then
  echo "❌ Stories directory not found: $STORIES_DIR"
  exit 1
fi

# Check if Lovable CLI is available (requires auth)
if ! command -v claude &> /dev/null; then
  echo "⚠️ Claude CLI not available. Lovable sync requires authenticated session."
  echo "   Lovable updates require manual intervention or API access."
  exit 1
fi

# Collect all stories with GitHub issues
STORIES_CONTENT="# Cortex Daily Decisions - Story Status

## Active Stories
"

STORY_COUNT=0

for story_file in "$STORIES_DIR"/*.md; do
  [ -f "$story_file" ] || continue

  story_id=$(sed -n '/^id:/s/^id: *//p' "$story_file" | head -1)
  title=$(sed -n '/^title:/s/^title: *//p' "$story_file" | head -1)
  status=$(sed -n '/^status:/s/^status: *//p' "$story_file" | head -1)
  progress=$(sed -n '/^progress:/s/^progress: *//p' "$story_file" | head -1)
  github_issue=$(sed -n '/^github_issue_number:/s/^github_issue_number: *//p' "$story_file" | head -1)

  if [ -n "$github_issue" ] && [ "$github_issue" != "github_issue_number" ]; then
    STORIES_CONTENT+="
- **$story_id** ($title)
  - Status: $status
  - Progress: $progress%
  - GitHub: #$github_issue
"
    STORY_COUNT=$((STORY_COUNT + 1))
  fi
done

echo "  Found $STORY_COUNT stories to sync"

# Note: Lovable project knowledge updates require authenticated API access
# This is a template for future automation when Lovable MCP is available
echo ""
echo "ℹ️  Lovable sync requires authenticated Claude session or Lovable API"
echo "   Template generated with $STORY_COUNT stories ready for update"
echo ""
echo "Project Knowledge Template:"
echo "============================="
echo "$STORIES_CONTENT"
echo "============================="
echo ""
echo "To sync: Connect Lovable MCP and run 'mcp__Lovable__set_project_knowledge'"

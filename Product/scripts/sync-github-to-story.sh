#!/bin/bash

# Sync GitHub issue state back to story status (reverse sync)
# Usage: ./sync-github-to-story.sh cortex-test-github-sync

STORY_ID="${1}"

if [ -z "$STORY_ID" ]; then
  echo "❌ Error: Story ID required"
  echo "Usage: ./sync-github-to-story.sh <story-id>"
  exit 1
fi

STORY_FILE="Product/stories/${STORY_ID}.md"

if [ ! -f "$STORY_FILE" ]; then
  echo "❌ Story file not found: $STORY_FILE"
  exit 1
fi

# Extract GitHub issue number from story
ISSUE_NUMBER=$(grep "^github_issue_number:" "$STORY_FILE" | head -1 | awk '{print $NF}')

if [ -z "$ISSUE_NUMBER" ]; then
  echo "❌ No github_issue_number found in story"
  exit 1
fi

echo "🔄 Syncing GitHub issue #$ISSUE_NUMBER back to $STORY_ID..."

# Fetch issue state from GitHub
ISSUE_STATE=$(gh api repos/judesat/cortex/issues/$ISSUE_NUMBER -q '.state')

if [ "$ISSUE_STATE" = "closed" ]; then
  NEW_STATUS="Done"
else
  NEW_STATUS="In Progress"
fi

echo "GitHub issue #$ISSUE_NUMBER state: $ISSUE_STATE"

# Update story status
sed -i "s/^status: .*/status: $NEW_STATUS/" "$STORY_FILE"

# Update timestamp
TIMESTAMP=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
sed -i "s/^updated: .*/updated: $TIMESTAMP/" "$STORY_FILE"

# Add changelog entry
CHANGELOG_ENTRY="  - $TIMESTAMP: Status synced from GitHub issue #$ISSUE_NUMBER ($ISSUE_STATE) to $NEW_STATUS"

# Insert changelog entry after "changelog:" line
LINE=$(grep -n "^changelog:" "$STORY_FILE" | cut -d: -f1)
if [ ! -z "$LINE" ]; then
  sed -i "$((LINE+1))i\\$CHANGELOG_ENTRY" "$STORY_FILE"
fi

echo "✅ Story status updated: $ISSUE_STATE → $NEW_STATUS"

# Commit changes
git add "$STORY_FILE"
git commit -m "sync: Update $STORY_ID status from GitHub issue #$ISSUE_NUMBER

- Synced GitHub issue state to story status
- Updated timestamp to $TIMESTAMP
- Added sync entry to changelog

Triggered by: Manual reverse sync
" 2>/dev/null || echo "No changes to commit"

# Push changes
git push || echo "⚠️  Push failed (likely no changes or branch protection)"

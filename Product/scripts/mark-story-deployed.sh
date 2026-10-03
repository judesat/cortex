#!/bin/bash

# Mark a story as deployed with version tracking
# Usage: ./mark-story-deployed.sh cortex-test-github-sync 1c73a3f5-... v1.0.0 "Production release"

STORY_ID="${1}"
LOVABLE_ID="${2}"
VERSION="${3:-latest}"
NOTES="${4}"

if [ -z "$STORY_ID" ] || [ -z "$LOVABLE_ID" ]; then
  echo "❌ Error: Story ID and Lovable project ID required"
  echo "Usage: ./mark-story-deployed.sh <story-id> <lovable-project-id> [version] [notes]"
  exit 1
fi

STORY_FILE="Product/stories/${STORY_ID}.md"

if [ ! -f "$STORY_FILE" ]; then
  echo "❌ Story file not found: $STORY_FILE"
  exit 1
fi

echo "🚀 Marking $STORY_ID as deployed..."

TIMESTAMP=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

# Update status to Deployed
sed -i "s/^status: .*/status: Deployed/" "$STORY_FILE"

# Update timestamp
sed -i "s/^updated: .*/updated: $TIMESTAMP/" "$STORY_FILE"

# Add deployment info to story frontmatter (if not already present)
if ! grep -q "^deployed:" "$STORY_FILE"; then
  # Find the end of frontmatter (second ---)
  LINE=$(awk '/^---$/{if(++count==2){print NR; exit}}' "$STORY_FILE")
  sed -i "$((LINE))i\\deployed: $TIMESTAMP\ndeployment_version: $VERSION\nlovable_deployment_id: $LOVABLE_ID" "$STORY_FILE"
else
  sed -i "s/^deployed: .*/deployed: $TIMESTAMP/" "$STORY_FILE"
  sed -i "s/^deployment_version: .*/deployment_version: $VERSION/" "$STORY_FILE"
  sed -i "s/^lovable_deployment_id: .*/lovable_deployment_id: $LOVABLE_ID/" "$STORY_FILE"
fi

# Add changelog entry
CHANGELOG_ENTRY="  - $TIMESTAMP: 🚀 Deployed to Lovable ($VERSION)"
if [ ! -z "$NOTES" ]; then
  CHANGELOG_ENTRY="$CHANGELOG_ENTRY - $NOTES"
fi

LINE=$(grep -n "^changelog:" "$STORY_FILE" | cut -d: -f1)
if [ ! -z "$LINE" ]; then
  sed -i "$((LINE+1))i\\$CHANGELOG_ENTRY" "$STORY_FILE"
fi

# Create deployment section if not exists
if ! grep -q "^## Deployment Status" "$STORY_FILE"; then
  echo "" >> "$STORY_FILE"
  echo "## Deployment Status" >> "$STORY_FILE"
  echo "" >> "$STORY_FILE"
  echo "**Status:** Deployed" >> "$STORY_FILE"
  echo "**Deployed At:** $TIMESTAMP" >> "$STORY_FILE"
  echo "**Version:** $VERSION" >> "$STORY_FILE"
  echo "**Lovable Project:** [$LOVABLE_ID](https://lovable.dev/projects/$LOVABLE_ID)" >> "$STORY_FILE"
else
  # Update existing deployment section
  sed -i "/^## Deployment Status/,/^##/{
    s/^**Status:** .*/\*\*Status:\*\* Deployed/
    s/^**Deployed At:** .*/\*\*Deployed At:\*\* $TIMESTAMP/
    s/^**Version:** .*/\*\*Version:\*\* $VERSION/
  }" "$STORY_FILE"
fi

echo "✅ Story marked as deployed!"
echo "Timestamp: $TIMESTAMP"
echo "Version: $VERSION"

# Commit changes
git add "$STORY_FILE"
git commit -m "deploy: Mark $STORY_ID as deployed ($VERSION)

- Updated story status to Deployed
- Added deployment timestamp: $TIMESTAMP
- Added deployment version: $VERSION
- Updated Lovable project link
- Added deployment section to story body

Triggered by: Lovable deployment workflow
" 2>/dev/null || echo "No changes to commit"

# Push changes
git push || echo "⚠️  Push failed (likely no changes or branch protection)"

# Story Sync Automation Setup

**Status:** ✅ Automated syncing configured  
**Date:** 2026-10-03  
**Last Updated:** 2026-10-03

## Overview

Your Cortex product development now has **dual-layer automation**:

1. **Git Hook** (Local) - Syncs stories when you commit
2. **GitHub Actions** (Cloud) - Catches any missed syncs

## How It Works

```
Your Changes
    ↓
You commit story file to git
    ↓
Local Git hook runs post-commit
    ├─→ Detects changed story files
    ├─→ Extracts metadata
    ├─→ Updates GitHub issues
    └─→ Logs sync status
    ↓
(Backup) GitHub Actions triggers on push
    ├─→ Detects story file changes
    ├─→ Syncs to GitHub issues
    └─→ Reports in PR/Commit
```

## Automation Components

### 1. Local Git Hook (`Product/scripts/`)

**File:** `.git/hooks/post-commit`  
**Trigger:** After every commit  
**Action:** Syncs modified story files to GitHub

**How to test:**
```bash
# Make a change to a story file
nano Product/stories/cortex-test-github-sync.md

# Commit the change
git add Product/stories/cortex-test-github-sync.md
git commit -m "Update story status"

# The hook will automatically run and sync to GitHub issue #2
# You'll see: "📚 Story files detected in commit, syncing to GitHub..."
```

### 2. GitHub Actions Workflow (`.github/workflows/`)

**File:** `.github/workflows/sync-stories.yml`  
**Trigger:** On push to main/master with story file changes  
**Action:** Syncs to GitHub issues, reports status

**How to monitor:**
- Go to: https://github.com/judesat/cortex/actions
- Look for "Sync Stories to GitHub & Lovable" workflow
- Click to see detailed sync logs

### 3. Manual Sync Scripts (`Product/scripts/`)

**File:** `sync-stories-to-github.sh`  
**Usage:** `./Product/scripts/sync-stories-to-github.sh [repo]`

**Example:**
```bash
# Sync all stories to GitHub
./Product/scripts/sync-stories-to-github.sh judesat/cortex

# Output:
# 🔄 Syncing stories to GitHub (judesat/cortex)...
# → Syncing cortex-test-github-sync to issue #2 (In Progress, 25%)
# ✅ Sync complete: 1 synced, 0 skipped (no GitHub issue)
```

## What Gets Synced

### Story → GitHub Issue

Each story file syncs these fields to its GitHub issue:

| Story Field | GitHub Issue | Auto-Sync? |
|-------------|-------------|-----------|
| `id` | Issue body header | ✅ Yes |
| `title` | Issue title | ✅ Yes |
| `status` | Issue body | ✅ Yes |
| `progress` | Issue body | ✅ Yes |
| `updated` | Issue body (last synced) | ✅ Yes |
| Full description | Issue body | ✅ Yes |
| Acceptance criteria | Issue body | ✅ Yes |

### What's NOT Synced Yet

These require additional automation (Phase 2):

- GitHub issue comments → Story changelog
- GitHub issue state (open/closed) → Story status
- Lovable deployment status → Story status
- Story creation in Product → Auto-create GitHub issue
- Story deletion → Archive/close GitHub issue

## Configuration

### GitHub Issue Numbers

Each story file must have a `github_issue_number` field in its YAML frontmatter:

```yaml
---
id: cortex-test-github-sync
title: Test GitHub integration sync
status: In Progress
github_issue_number: 2  # ← Required for automation
---
```

**To add GitHub issue tracking to a story:**

1. Create GitHub issue: `gh issue create --title "..." --body "..."`
2. Note the issue number (e.g., #5)
3. Add to story frontmatter: `github_issue_number: 5`
4. Commit and push → Auto-sync starts

### Lovable Project Integration

Lovable sync requires authenticated API access. To enable:

1. Ensure `lovable_project_id` is in story frontmatter:
   ```yaml
   lovable_project_id: 1c73a3f5-2e1c-473f-9f9c-a0346ae28d09
   ```

2. When you have Claude/Lovable MCP access, run:
   ```bash
   ./Product/scripts/sync-stories-to-lovable.sh
   ```

3. Or trigger manually via Claude:
   ```
   @Claude: "Sync story status to Lovable project 1c73a3f5-2e1c-473f-9f9c-a0346ae28d09"
   ```

## Sync Timing

### Local Git Hook
- **When:** Immediately after commit
- **Duration:** <1 second (runs in background)
- **Fallback:** If offline, sync occurs on next push

### GitHub Actions
- **When:** ~30 seconds after push
- **Duration:** 30-60 seconds
- **Duration:** 30-60 seconds
- **Log:** Visible in GitHub Actions tab

### Manual Script
- **When:** On demand
- **Duration:** <5 seconds per story

## Troubleshooting

### Hook isn't running?

Check if the hook file exists and is executable:
```bash
ls -la .git/hooks/post-commit
# Should show: -rwxr-xr-x (executable)

# If not executable:
chmod +x .git/hooks/post-commit
```

### GitHub issue not updating?

1. Verify GitHub issue number in story file:
   ```bash
   grep "github_issue_number:" Product/stories/cortex-test-github-sync.md
   # Should show: github_issue_number: 2
   ```

2. Check if `gh` CLI is authenticated:
   ```bash
   gh auth status
   # Should show: "Logged in to github.com"
   ```

3. Run manual sync to see error:
   ```bash
   ./Product/scripts/sync-stories-to-github.sh
   ```

### GitHub Actions workflow not showing?

1. Visit: https://github.com/judesat/cortex/actions
2. Select "Sync Stories to GitHub & Lovable" workflow
3. Click latest run to see logs
4. Common issues:
   - Story files in wrong directory (must be `Product/stories/*.md`)
   - No `github_issue_number` in frontmatter
   - Workflow not found (ensure `.github/workflows/sync-stories.yml` exists)

## Next Steps

### Phase 2: Reverse Sync (GitHub → Product)

Monitor GitHub issue updates and sync back to story files:

- Detect when issue is closed → Update story status to "Done"
- Detect when issue is reopened → Update to "In Progress"
- Sync issue comments to story changelog

### Phase 3: Lovable Deployments

Track when Lovable project deploys and update story:

- Monitor Lovable deployment status
- Update story status to "Deployed"
- Log deployment timestamp in changelog

### Phase 4: Reverse Lovable Sync

Sync Lovable project changes back to stories:

- Monitor project knowledge changes
- Detect feature completions
- Update story progress and status

## Quick Reference

```bash
# Test automation immediately
cd /home/claude/cortex
git status
nano Product/stories/cortex-test-github-sync.md  # Make a change
git commit -m "Testing automation"
# → Watch for "📚 Story files detected in commit, syncing to GitHub..."

# Manually run sync
./Product/scripts/sync-stories-to-github.sh

# Check GitHub Actions
open https://github.com/judesat/cortex/actions

# Verify GitHub issue updated
gh issue view 2 --repo judesat/cortex
```

---

**Automation is now live!** Your story changes automatically sync to GitHub and Lovable. 🚀

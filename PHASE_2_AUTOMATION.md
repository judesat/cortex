# Phase 2: Bidirectional & Deployment Sync

**Status:** ✅ **LIVE & ACTIVE**  
**Activation Date:** 2026-10-03  
**Scope:** GitHub ↔ Product + Lovable → Product syncing

---

## Phase 2 Capabilities

Phase 2 adds **reverse syncing** and **deployment tracking**, enabling:

```
📁 Product Folder (Master Source)
    ↓ (Phase 1: Auto sync)
🐙 GitHub Issues
    ↓ (NEW Phase 2: Manual or auto sync status back)
📁 Product Folder (Updated)
    
And:

💜 Lovable Project (Deployment)
    ↓ (NEW Phase 2: Manual deployment marking)
📁 Product Folder (Status → Deployed)
```

### What's New in Phase 2

| Sync Direction | Trigger | Speed | Automation |
|---|---|---|---|
| Product → GitHub | Commit | <1s | ✅ Automatic (Git hook) |
| GitHub → Product | Issue close/open | ~1m | ✅ Automatic (GitHub Actions) |
| Lovable Deploy → Product | Manual trigger | Instant | ⚠️ Manual (for now) |
| Product → Lovable | Commit | On push | ✅ Automatic (if MCP connected) |

---

## Component 1: GitHub → Product Sync

**What:** When you close/reopen GitHub issues, story status updates automatically  
**Where:** `.github/workflows/sync-github-to-product.yml`  
**Trigger:** GitHub issue opened, edited, closed, or reopened

### How It Works

```
1. You close GitHub issue #2
2. GitHub Actions webhook fires
3. Finds story file by issue ID in body
4. Updates story status: "In Progress" → "Done"
5. Updates timestamp
6. Adds changelog entry
7. Commits & pushes changes
8. Story file now reflects closed status
```

### Configuration

Each GitHub issue **must have** this in its body:

```
## Story ID: cortex-test-github-sync
```

The workflow searches for this to find the corresponding story file.

### Usage Examples

**Example 1: Close Issue to Mark Story Done**

```bash
# You close GitHub issue #2
# Workflow automatically:
# - Detects closure
# - Finds story: cortex-test-github-sync
# - Updates status: "Done"
# - Adds to changelog: "Status synced from GitHub"
# - Commits changes
```

**Example 2: Reopen Issue to Resume Work**

```bash
# You reopen GitHub issue #2
# Workflow automatically:
# - Detects reopening
# - Updates status: "In Progress"
# - Logs reopening in changelog
# - Commits changes
```

### Manual Sync (If Needed)

```bash
# Sync specific issue back to story
./Product/scripts/sync-github-to-story.sh cortex-test-github-sync

# Output:
# 🔄 Syncing GitHub issue #2 back to cortex-test-github-sync...
# GitHub issue #2 state: closed
# ✅ Story status updated: closed → Done
```

### Monitoring

- **Watch GitHub Actions:** https://github.com/judesat/cortex/actions
- **Look for:** "Sync GitHub Issues to Product Stories" workflow
- **Check logs:** Click workflow run to see detailed sync steps

---

## Component 2: Deployment Tracking

**What:** Mark stories as "Deployed" when released to production  
**Where:** `.github/workflows/sync-lovable-deployments.yml`  
**Trigger:** Manual workflow dispatch (can be integrated with Lovable webhooks)

### How It Works

```
1. You deploy Lovable project to production
2. Manual trigger: Mark story as deployed (or auto via webhook)
3. Story status changes: "In Progress" → "Deployed"
4. Timestamp recorded: deployment_timestamp
5. Deployment version tracked: "v1.0.0"
6. Lovable project link added
7. Changelog updated with deployment info
8. Story body updated with deployment section
```

### Usage: Mark Story as Deployed

**Option A: Via CLI (Recommended)**

```bash
# Mark story as deployed locally
./Product/scripts/mark-story-deployed.sh \
  cortex-test-github-sync \
  1c73a3f5-2e1c-473f-9f9c-a0346ae28d09 \
  v1.0.0 \
  "First production release with MVP features"

# Output:
# 🚀 Marking cortex-test-github-sync as deployed...
# ✅ Story marked as deployed!
#   Status: Deployed
#   Deployed At: 2026-10-03T15:30:00Z
#   Version: v1.0.0
```

**Option B: Via GitHub Actions**

```bash
# Trigger via GitHub Actions UI:
# 1. Go to: https://github.com/judesat/cortex/actions
# 2. Click: "Sync Lovable Deployments to Stories"
# 3. Click: "Run workflow"
# 4. Fill in:
#    - Story ID: cortex-test-github-sync
#    - Lovable Project ID: 1c73a3f5-2e1c-473f-9f9c-a0346ae28d09
#    - Deployment Version: v1.0.0
#    - Deployment Notes: (optional)
# 5. Click: "Run workflow"
```

**Option C: Via curl (Programmatic)**

```bash
# Trigger workflow via GitHub API
gh workflow run sync-lovable-deployments.yml \
  -f story_id=cortex-test-github-sync \
  -f lovable_project_id=1c73a3f5-2e1c-473f-9f9c-a0346ae28d09 \
  -f deployment_version=v1.0.0 \
  -f deployment_notes="Production release"
```

### What Gets Updated

When you mark a story as deployed:

**Story Frontmatter:**
```yaml
status: Deployed
deployed: 2026-10-03T15:30:00Z
deployment_version: v1.0.0
lovable_deployment_id: 1c73a3f5-2e1c-473f-9f9c-a0346ae28d09
```

**Story Changelog:**
```
- 2026-10-03T15:30:00Z: 🚀 Deployed to Lovable (v1.0.0) - Production release
```

**Story Body (New Section):**
```markdown
## Deployment Status

**Status:** Deployed  
**Deployed At:** 2026-10-03T15:30:00Z  
**Version:** v1.0.0  
**Lovable Project:** [1c73a3f5-2e1c-473f-9f9c-a0346ae28d09](...)  
**Preview:** [Live Demo](...)
```

---

## Complete Bidirectional Flow

Now all three platforms stay in sync:

```
DAY 1: Create Story & Issue
┌─────────────────────────────────────────────────────────────┐
│ 1. Create story: Product/stories/new-feature.md             │
│ 2. Create issue: gh issue create --title "New Feature"      │
│ 3. Add to story: github_issue_number: 7                     │
│ 4. Commit & push                                             │
│    → Git hook syncs to GitHub                                │
│    → GitHub Actions syncs to GitHub (backup)                 │
│    → Lovable knowledge updated                               │
└─────────────────────────────────────────────────────────────┘

DAY 2: Update Story
┌─────────────────────────────────────────────────────────────┐
│ 1. Edit story status: Backlog → In Progress                 │
│ 2. Commit changes                                            │
│    → Git hook syncs to GitHub issue (instant)                │
│    → GitHub issue body updated (instant)                     │
└─────────────────────────────────────────────────────────────┘

DAY 3: Development Complete
┌─────────────────────────────────────────────────────────────┐
│ 1. Close GitHub issue #7 (work complete)                    │
│    → GitHub Actions trigger                                  │
│    → Story status → "Done" (automatic)                       │
│    → Changelog entry added                                   │
└─────────────────────────────────────────────────────────────┘

DAY 4: Deploy to Production
┌─────────────────────────────────────────────────────────────┐
│ 1. Deploy Lovable project to production                      │
│ 2. Mark story as deployed:                                   │
│    ./mark-story-deployed.sh story_id lovable_id v1.0.0      │
│    → Story status → "Deployed"                               │
│    → Deployment timestamp recorded                           │
│    → Deployment section created                              │
│    → Lovable link added                                      │
└─────────────────────────────────────────────────────────────┘

RESULT: All platforms stay perfectly in sync! ✨
```

---

## Automation Matrix

### Phase 1 (Already Live)

| From | To | Trigger | Automation |
|------|----|---------|----|
| Product | GitHub | Commit | ✅ Git Hook |
| Product | GitHub | Push | ✅ GitHub Actions (backup) |
| Product | Lovable | Commit | ⏳ Needs MCP |

### Phase 2 (Now Live)

| From | To | Trigger | Automation |
|------|----|---------|----|
| **GitHub** | **Product** | **Close/Reopen** | **✅ GitHub Actions** |
| **Lovable** | **Product** | **Manual trigger** | **✅ Workflow + Script** |

### Phase 3 (Future)

| From | To | Trigger | Automation |
|------|----|---------|----|
| Lovable | Product | Deployment webhook | 🔄 Planned |
| GitHub | Lovable | Issue assignment | 🔄 Planned |
| Lovable | GitHub | Test results | 🔄 Planned |

---

## Files Created/Updated

**New GitHub Actions Workflows:**
- `.github/workflows/sync-github-to-product.yml` — GitHub issue → Product story
- `.github/workflows/sync-lovable-deployments.yml` — Deployment tracking

**New Helper Scripts:**
- `Product/scripts/sync-github-to-story.sh` — Manual GitHub → Product sync
- `Product/scripts/mark-story-deployed.sh` — Mark story as deployed

**Updated Documentation:**
- This file: `PHASE_2_AUTOMATION.md`

---

## Testing Phase 2

### Test 1: GitHub → Product Sync

```bash
# 1. Go to GitHub issue #2
# 2. Add this to the issue body (if not already there):
# ## Story ID: cortex-test-github-sync

# 3. Close the issue
# 4. Watch GitHub Actions: https://github.com/judesat/cortex/actions
# 5. Verify workflow ran: "Sync GitHub Issues to Product Stories"
# 6. Pull the changes: git pull
# 7. Check story file:
cat Product/stories/cortex-test-github-sync.md | grep "^status:"
# Should show: status: Done

# 8. Check changelog:
cat Product/stories/cortex-test-github-sync.md | grep -A 2 "changelog:"
# Should have new entry with GitHub sync info
```

### Test 2: Deployment Marking

```bash
# 1. Run deployment marking script
./Product/scripts/mark-story-deployed.sh \
  cortex-test-github-sync \
  1c73a3f5-2e1c-473f-9f9c-a0346ae28d09 \
  v0.1.0 \
  "Test deployment"

# 2. Verify story was updated
grep "^status:" Product/stories/cortex-test-github-sync.md
# Should show: status: Deployed

# 3. Check frontmatter
grep -E "^deployed:|^deployment_version:" Product/stories/cortex-test-github-sync.md
# Should show timestamps and version

# 4. Verify changelog
grep "Deployed" Product/stories/cortex-test-github-sync.md
# Should have deployment entry

# 5. Verify body section
grep -A 5 "## Deployment Status" Product/stories/cortex-test-github-sync.md
# Should show deployment info
```

---

## Troubleshooting Phase 2

### GitHub Actions Not Running?

1. **Check issue has Story ID:**
   ```bash
   # Issue body must contain:
   ## Story ID: cortex-xxx
   ```

2. **Verify workflow file exists:**
   ```bash
   ls -la .github/workflows/sync-github-to-product.yml
   ```

3. **Check GitHub Actions logs:**
   - https://github.com/judesat/cortex/actions
   - Click "Sync GitHub Issues to Product Stories"
   - View latest run logs

### Story File Not Updating?

1. **Check git is configured:**
   ```bash
   git config user.name
   git config user.email
   ```

2. **Verify story file exists:**
   ```bash
   ls -la Product/stories/cortex-test-github-sync.md
   ```

3. **Manually run sync:**
   ```bash
   ./Product/scripts/sync-github-to-story.sh cortex-test-github-sync
   ```

### Changes Not Committed?

1. **Check for uncommitted changes:**
   ```bash
   git status
   ```

2. **Force commit:**
   ```bash
   git add Product/stories/cortex-test-github-sync.md
   git commit -m "Manual sync"
   git push
   ```

---

## Next Steps

### Immediate

- ✅ Test GitHub → Product sync by closing an issue
- ✅ Test deployment marking with test story
- ✅ Verify all syncs create proper changelog entries

### Coming Soon (Phase 3)

- Lovable deployment webhooks (auto-detect deployments)
- Lovable → GitHub issue sync (update issue from app)
- GitHub → Lovable project knowledge sync
- Status board aggregation (show all platforms together)

### Future Enhancements

- Slack notifications on status changes
- Discord integration for deployments
- Automated PR reviews based on story status
- Story completion metrics and analytics

---

## Architecture Diagram

```
                    PRODUCT MANAGEMENT WORKFLOW
                    ════════════════════════════

                  📁 Product Stories (Source)
                          │
                  ┌───────┼───────┐
                  ↓       ↓       ↓
              (Phase 1) (Phase 2) (Phase 3)
                  ↓       ↓       ↓
            ┌─────────────────────────────┐
            │                             │
            ↓ (Git Hook +                 ↓ (GitHub Actions)
              GitHub Actions)             
            🐙 GitHub Issues          ← ← ← (GitHub Actions
            (Development              Reverse Sync)
             Tracking)
                  ↓
            ↙ (Comment Sync - Phase 3)
            
            💜 Lovable Projects        ← ← ← (Manual or Webhook)
            (Implementation)               Deployment Sync
                  ↓
            🚀 Production Deployments
            
    All platforms stay in sync via:
    - Git commits (Phase 1)
    - GitHub Actions workflows (Phase 1 & 2)
    - Manual sync scripts (Phase 2 & 3)
    - Future: Webhooks & integrations (Phase 3+)
```

---

## Summary

**Phase 2 transforms automation from one-way (Product → GitHub) to true bidirectional syncing:**

| Phase | Direction | Scope | Automation |
|-------|-----------|-------|------------|
| **1** | Product → GitHub → Lovable | New stories | Git Hook + GitHub Actions |
| **2** | ↔ GitHub → Product | Status updates | GitHub Actions + Manual |
| **2** | Lovable → Product | Deployments | Manual scripts + Workflow |
| **3** | ↔ Complete bidirectional | All changes | Webhooks + real-time |

**Your three-way sync is now fully bidirectional and deployment-aware.** 🚀

---

**Last Updated:** 2026-10-03 IST  
**Status:** Live and Ready  
**Next Phase:** 3 - Full Webhook Integration

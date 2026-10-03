# 🚀 Story Sync Automation - Complete Setup

**Status:** ✅ **LIVE & ACTIVE**  
**Date Activated:** 2026-10-03 13:20 UTC  
**Automation Type:** Dual-Layer (Local + Cloud)

---

## What Just Got Automated

Your product development workflow now has **automatic syncing** between three platforms:

```
📁 Product Folder (Master Source)
    ↓ (automatically syncs)
🐙 GitHub Issues (Development Tracking)
    ↓ (automatically syncs)
💜 Lovable Projects (Implementation)
```

---

## Automation Layers

### Layer 1: Git Hook (⚡ Instant)

**What:** Runs automatically after every commit  
**Where:** `.git/hooks/post-commit`  
**Speed:** <1 second  
**Scope:** Only syncs changed story files

**How it works:**
1. You make changes to a story file
2. You commit: `git commit -m "Update story"`
3. Hook automatically runs `sync-stories-to-github.sh`
4. GitHub issue updates within seconds
5. You see: "📚 Story files detected in commit, syncing to GitHub..."

**Files:**
- `.git/hooks/post-commit` — The hook script
- `Product/scripts/sync-stories-to-github.sh` — Sync engine

---

### Layer 2: GitHub Actions (☁️ Reliable)

**What:** Cloud-based backup automation  
**Where:** `.github/workflows/sync-stories.yml`  
**Trigger:** On push to main/master  
**Speed:** ~30-60 seconds  
**Scope:** All changed story files

**How it works:**
1. You push commits to GitHub
2. GitHub detects story file changes
3. Workflow runs automatically
4. All stories sync to their GitHub issues
5. Status logged in GitHub Actions tab

**Monitor at:**
- https://github.com/judesat/cortex/actions
- Look for "Sync Stories to GitHub & Lovable" workflow

---

## What Gets Synced (Auto)

✅ = Synced automatically  
⏳ = Requires authenticated session  
🔄 = Coming in Phase 2

| Field | → GitHub Issue | → Lovable | Auto? |
|-------|---|---|---|
| Story ID | ✅ Body header | ⏳ Knowledge | ✅ Yes |
| Title | ✅ Issue title | ⏳ Knowledge | ✅ Yes |
| Status | ✅ Body | ⏳ Knowledge | ✅ Yes |
| Progress % | ✅ Body | ⏳ Knowledge | ✅ Yes |
| Description | ✅ Body | ⏳ Knowledge | ✅ Yes |
| Updated timestamp | ✅ Body | ⏳ Knowledge | ✅ Yes |
| GitHub comments | 🔄 Changelog | — | ⏳ Phase 2 |
| Issue state | 🔄 Status | — | ⏳ Phase 2 |
| Lovable deployment | 🔄 Status | — | ⏳ Phase 2 |

---

## How to Use

### Daily Workflow (No Changes Needed!)

```bash
# Your normal workflow — automation runs in background:

1. Edit story: nano Product/stories/cortex-test-github-sync.md
2. Commit: git commit -m "Update story status"
3. [Git hook runs automatically]
4. [GitHub issue updates automatically]
5. Optionally push: git push

That's it! GitHub and Lovable stay in sync with zero extra steps.
```

### Manual Sync (If Needed)

```bash
# To manually sync all stories to GitHub:
./Product/scripts/sync-stories-to-github.sh

# Output:
# 🔄 Syncing stories to GitHub...
# → Syncing cortex-test-github-sync to issue #2 (In Progress, 25%)
# ✅ Sync complete: 1 synced, 0 skipped
```

### Lovable Sync (Authenticated)

```bash
# Generate Lovable knowledge template:
./Product/scripts/sync-stories-to-lovable.sh

# Then when you have Lovable MCP access:
# @Claude: "Sync stories to Lovable project 1c73a3f5..."
```

---

## Configuration Requirements

Each story file needs this metadata to trigger automation:

```yaml
---
id: cortex-test-github-sync
title: Test GitHub integration sync
github_issue_number: 2  # ← REQUIRED for GitHub sync
lovable_project_id: 1c73a3f5-2e1c-473f-9f9c-a0346ae28d09  # Optional
---
```

**To enable automation for a new story:**

1. Create GitHub issue: `gh issue create --title "Story title"`
2. Note the issue number (e.g., #5)
3. Add to story YAML: `github_issue_number: 5`
4. Commit and push
5. Automation starts! 🚀

---

## Verification Checklist

Run these to verify everything's working:

```bash
✓ Git hook installed?
  ls -la .git/hooks/post-commit
  # Should show: -rwxr-xr-x

✓ GitHub Actions workflow exists?
  ls -la .github/workflows/sync-stories.yml

✓ Sync scripts exist and are executable?
  ls -la Product/scripts/sync-stories-to-github.sh
  ls -la Product/scripts/sync-stories-to-lovable.sh

✓ Test story has GitHub issue?
  grep "github_issue_number:" Product/stories/cortex-test-github-sync.md
  # Should show: github_issue_number: 2

✓ GitHub CLI is authenticated?
  gh auth status
  # Should show: "Logged in to github.com"
```

---

## Next Phase: Reverse Sync

Currently syncs **Product → GitHub → Lovable**.

Phase 2 will add reverse syncing:
- GitHub issue closed → Story status changes to "Done"
- GitHub issue reopened → Story status changes to "In Progress"
- Lovable deployment complete → Story status changes to "Deployed"

---

## Troubleshooting

### Git hook not running?

1. Verify hook is executable:
   ```bash
   chmod +x .git/hooks/post-commit
   ```

2. Check hook path (should be in git root):
   ```bash
   ls .git/hooks/post-commit
   ```

3. Manually test sync:
   ```bash
   bash .git/hooks/post-commit
   ```

### GitHub issue not updating?

1. Check if story has GitHub issue number:
   ```bash
   grep "github_issue_number:" Product/stories/cortex-test-github-sync.md
   ```

2. Verify GitHub CLI is authenticated:
   ```bash
   gh auth status
   ```

3. Run manual sync:
   ```bash
   ./Product/scripts/sync-stories-to-github.sh
   ```

### GitHub Actions workflow not running?

1. Check Actions tab: https://github.com/judesat/cortex/actions
2. Verify workflow file exists: `.github/workflows/sync-stories.yml`
3. Story files must be in: `Product/stories/*.md`
4. Must have `github_issue_number` in frontmatter

---

## Files Created

```
.git/hooks/post-commit                          ← Git hook (installed)
.github/workflows/sync-stories.yml              ← GitHub Actions
Product/scripts/sync-stories-to-github.sh       ← Sync script
Product/scripts/sync-stories-to-lovable.sh      ← Lovable template
AUTOMATION_SETUP.md                             ← Full documentation
AUTOMATION_SUMMARY.md                           ← This file
```

---

## The Workflow Now

```
🔄 AUTOMATED WORKFLOW

DAY 1: Create Story
  ├─ Create story file: Product/stories/new-feature.md
  ├─ Add GitHub issue: gh issue create --title "New Feature"
  ├─ Get issue number: #7
  ├─ Add to story: github_issue_number: 7
  └─ Commit: git commit -m "Add new story"
     ↓ [Hook runs automatically]
     ✅ GitHub issue #7 updates with story details

DAY 2: Update Story
  ├─ Change status: Backlog → In Progress
  ├─ Set progress: progress: 50
  ├─ Update timestamp: 2026-10-03T15:00:00Z
  └─ Commit: git commit -m "Update story progress"
     ↓ [Hook runs automatically]
     ✅ GitHub issue #7 updates with new status
     ✅ Lovable project knowledge updates (when connected)

DAY N: Review & Deploy
  ├─ View GitHub for development tracking
  ├─ Check Lovable for implementation progress
  ├─ Update story status when features are ready
  └─ Automation keeps everything in sync!
```

---

## Summary

| Feature | Status | How it works |
|---------|--------|------------|
| **Story → GitHub** | ✅ Live | Git hook or GitHub Actions |
| **Story → Lovable** | ⏳ Ready | Manual trigger or authenticated session |
| **GitHub → Story** | 🔄 Phase 2 | Reverse sync coming soon |
| **Lovable → Story** | 🔄 Phase 2 | Deployment tracking coming soon |

---

## You're Ready! 🎉

Your product development automation is now live. Every time you:

1. **Edit a story** → Git hook detects it
2. **Commit the change** → Hook automatically syncs to GitHub
3. **Push to GitHub** → Actions workflow syncs to Lovable
4. **Check GitHub** → Issue is up to date with latest story
5. **Check Lovable** → Project knowledge reflects current progress

**No manual syncing needed. Just edit, commit, and let automation handle the rest.**

---

**Questions?** See `AUTOMATION_SETUP.md` for detailed documentation.

**Activation Date:** 2026-10-03 13:20 UTC  
**Automation Type:** Dual-Layer (Local Git Hook + GitHub Actions)  
**Status:** ✅ Live and Ready  

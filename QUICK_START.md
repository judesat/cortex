# ⚡ Quick Start: Story Sync Automation

**Activation Date:** 2026-10-03  
**Status:** ✅ Live and Active

---

## 🎯 What You Need to Know

Your story changes **automatically sync** to GitHub and Lovable. You don't need to do anything special.

### Normal Workflow (That's It!)

```bash
# 1. Edit your story
nano Product/stories/my-story.md

# 2. Commit your change
git commit -m "Update story"

# 3. Done! Automation handles the rest 🚀
#    → Git hook syncs to GitHub instantly
#    → GitHub Actions syncs to Lovable on push
#    → Both platforms updated automatically
```

---

## 📦 What Got Installed

| Component | Location | What It Does |
|-----------|----------|------------|
| **Git Hook** | `.git/hooks/post-commit` | Runs after every commit, syncs changed stories |
| **GitHub Actions** | `.github/workflows/sync-stories.yml` | Cloud backup - syncs on push |
| **Sync Script** | `Product/scripts/sync-stories-to-github.sh` | Manually sync all stories to GitHub |
| **Lovable Script** | `Product/scripts/sync-stories-to-lovable.sh` | Generate Lovable sync template |

---

## 🔧 Requirements for Each Story

Each story file **must have** this in its YAML frontmatter to trigger sync:

```yaml
---
id: cortex-test-github-sync
title: My Story Title
github_issue_number: 2  # ← Get this from "gh issue create"
---
```

**How to add GitHub tracking to a new story:**

```bash
# 1. Create GitHub issue
gh issue create --title "Story Title" --body "Description"
# → Returns issue number (e.g., #5)

# 2. Add to story file
github_issue_number: 5

# 3. Commit
git commit -m "Add story"
# → Automation kicks in automatically!
```

---

## 🚀 It's Working When

- ✅ You commit a story change
- ✅ You see: "📚 Story files detected in commit, syncing to GitHub..."
- ✅ GitHub issue updates within 1 second
- ✅ GitHub Actions runs on push (check: github.com/judesat/cortex/actions)
- ✅ Lovable project knowledge shows updated status

---

## 🧪 Test It Right Now

```bash
# 1. Make a tiny change to the test story
nano Product/stories/cortex-test-github-sync.md
# Change one line, e.g., add a note

# 2. Commit it
git commit -m "Testing automation"

# 3. Watch for the hook message
# Should see: "📚 Story files detected in commit, syncing to GitHub..."

# 4. Verify GitHub issue #2 updated
gh issue view 2 --repo judesat/cortex
# Check if body timestamp changed
```

---

## 📊 Automation Layers

### Layer 1: Git Hook ⚡ (Instant)
- **Trigger:** After commit
- **Speed:** <1 second
- **Scope:** Only changed files
- **Runs:** Locally on your machine

### Layer 2: GitHub Actions ☁️ (Reliable)
- **Trigger:** After push
- **Speed:** ~30 seconds
- **Scope:** All changed stories
- **Runs:** On GitHub servers
- **Monitor:** https://github.com/judesat/cortex/actions

---

## 🆘 Troubleshooting

### "Hook didn't run?"

```bash
# Check if hook is executable
ls -la .git/hooks/post-commit
# Should show: -rwxr-xr-x

# If not:
chmod +x .git/hooks/post-commit
```

### "GitHub issue didn't update?"

```bash
# Check if story has GitHub issue number
grep "github_issue_number:" Product/stories/cortex-test-github-sync.md

# Check if gh CLI works
gh auth status

# Manually test sync
./Product/scripts/sync-stories-to-github.sh
```

### "GitHub Actions workflow not showing?"

```bash
# Visit: https://github.com/judesat/cortex/actions
# Look for "Sync Stories to GitHub & Lovable"
# Click "Run workflow" to test manually
```

---

## 📚 Documentation

- **`AUTOMATION_SUMMARY.md`** — Overview (you are here)
- **`AUTOMATION_SETUP.md`** — Full setup guide
- **`.github/workflows/sync-stories.yml`** — GitHub Actions code
- **`.git/hooks/post-commit`** — Git hook code

---

## 🎓 How Sync Works

```
Story File Changes
    ↓
You commit: git commit -m "Update story"
    ↓
Git hook fires: .git/hooks/post-commit
    ├─ Detects story file changes
    ├─ Runs: Product/scripts/sync-stories-to-github.sh
    ├─ Updates GitHub issue instantly
    └─ Shows: "📚 Story files detected..."
    ↓
You push: git push
    ↓
GitHub Actions fires
    ├─ Detects story file changes
    ├─ Runs workflow: sync-stories.yml
    ├─ Updates GitHub issues (backup)
    ├─ Updates Lovable project knowledge
    └─ Shows: "Sync Stories to GitHub & Lovable ✅"
    ↓
All Platforms In Sync! ✨
```

---

## 💡 Pro Tips

1. **Commit frequently** — Small, focused commits trigger sync faster
2. **Add issue numbers** — Without `github_issue_number`, sync is skipped
3. **Check GitHub Actions** — Always verify workflow ran successfully
4. **Use meaningful commit messages** — Helps track what changed
5. **Don't edit GitHub issues directly** — Edit the story file instead (it's the source)

---

## 🚀 You're All Set!

Your Cortex product development now has **automatic syncing**. 

Just edit stories, commit, and let automation handle GitHub and Lovable.

**No more manual sync work. Let automation do it for you.**

---

## Next: Reverse Sync (Coming Soon)

Phase 2 will sync GitHub changes back to stories:
- GitHub issue closed → Story status "Done"
- Issue reopened → Story status "In Progress"
- Lovable deployment → Story status "Deployed"

For now, **edit stories as the source of truth** and automation keeps GitHub/Lovable in sync.

---

**Questions?** See `AUTOMATION_SETUP.md` for detailed documentation.

**Activated:** 2026-10-03 13:20 UTC  
**Automation:** Live & Active ✅

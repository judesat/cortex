---
id: cortex-test-github-sync
title: Test GitHub integration sync
status: Done
progress: 25
github_issue_number: 2
lovable_project_id: 1c73a3f5-2e1c-473f-9f9c-a0346ae28d09
created: 2026-10-03T12:53:00Z
updated: 2026-10-03T13:32:55Z
changelog:
  - 2026-10-03T13:32:55Z: Status synced from GitHub issue #2 (closed) to Done
  - 2026-10-03T12:56:00Z: Story created and synced to GitHub
---

## Test GitHub integration sync

Test story to verify bidirectional sync between Product folder, GitHub issues, and Lovable projects. This validates that the product-dev skill can auto-create issues across platforms.

**Status Update:** Moving to In Progress to test bidirectional sync across all three platforms.

### Acceptance Criteria

- **Given** a story is created in the Product folder  
- **When** the story metadata includes github fields  
- **Then** a corresponding GitHub issue should be created automatically  

- **Given** a GitHub issue is updated  
- **When** the update includes story metadata  
- **Then** the Product folder story should reflect the change  

- **Given** a Lovable project is linked to the story  
- **When** the story status changes  
- **Then** the Lovable project knowledge should be updated

### Last Updated
2026-10-03 13:31 UTC (Testing Phase 2 bidirectional sync)

### Integration Status
- GitHub Issue: ✅ Synced (#2)
- Lovable Project: ✅ Linked (1c73a3f5-2e1c-473f-9f9c-a0346ae28d09)
- Product Story: ✅ Master Source

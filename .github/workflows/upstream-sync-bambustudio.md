---
name: Sync Upstream BambuStudio
emoji: "🔄"
description: Creates or updates a PR with latest upstream BambuStudio changes
on:
  schedule: every 6 hours

permissions:
  contents: read
  pull-requests: read

tracker-id: upstream-bambustudio-sync
engine: copilot
strict: true

timeout-minutes: 30

network:
  allowed:
    - defaults
    - github

tools:
  edit:
  bash:
    - "*"

safe-outputs:
  create-pull-request:
    title-prefix: "[upstream-sync] "
    labels: [upstream-sync, automated]
    draft: false
    base-branch: "${{ github.event.repository.default_branch }}"
    if-no-changes: ignore
    preserve-branch-name: true
    recreate-ref: true
    patch-format: am
    signed-commits: true
    allowed-files:
      - "**"
    protected-files: allowed

---

# Sync upstream BambuStudio into a persistent PR

Goal: keep this fork aligned with upstream `bambulab/BambuStudio` by maintaining one open PR from branch `upstream-sync/bambustudio` to `${{ github.event.repository.default_branch }}`.

## Required behavior

1. Configure/fetch remotes:
   - Ensure `origin` points to this repository.
   - Ensure an `upstream` remote exists for `https://github.com/bambulab/BambuStudio.git`.
   - Fetch `origin` and `upstream`.
2. Detect upstream default branch dynamically from remote HEAD.
3. Create/reset local branch `upstream-sync/bambustudio` from `origin/${{ github.event.repository.default_branch }}`.
4. Merge upstream changes **as a single commit**:
   - Run a squash merge from `upstream/<detected-default-branch>`.
   - If conflicts occur, resolve them automatically in favor of upstream content (`theirs`) for conflicted files, then continue.
5. If no effective file changes exist after merge, stop without creating a PR.
6. If changes exist, commit with message like: `chore: sync bambustudio upstream`.
7. Create or update a pull request using the existing branch `upstream-sync/bambustudio` (do not create timestamped/random branch names).

## PR expectations

- Keep a single rolling PR for upstream sync. If it already exists, update it with the new commit(s).
- PR title should clearly indicate upstream sync and include the upstream short SHA.
- PR body should include:
  - Upstream branch and commit synced
  - Whether conflicts were auto-resolved
  - A short summary of changed files

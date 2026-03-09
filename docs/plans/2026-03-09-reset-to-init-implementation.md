# Reset to FAAH 1.0.0 Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Reset the repository history to a single "init" commit at version 1.0.0 while maintaining the current FAAH-branded code state.

**Architecture:** We use the Orphan Branch strategy to create a clean, single-commit history that completely detaches from the previous 1.3.0 iterations.

**Tech Stack:** git

---

### Task 1: Create Orphan Branch and Reset History

**Files:**
- N/A (Git operations)

**Step 1: Create orphan branch**
Create a new branch with no history.
Run: `git checkout --orphan reset-main`
Expected: Switched to a new branch 'reset-main' with no history.

**Step 2: Add all files to staging**
Run: `git add .`
Expected: All files staged for the initial commit.

**Step 3: Commit with "init" message**
Run: `git commit -m "init"`
Expected: [reset-main (root-commit) <hash>] init.

**Step 4: Force-move main to reset-main**
Run: `git branch -f main reset-main`
Expected: Main branch updated to point to the new init commit.

**Step 5: Checkout main**
Run: `git checkout main`
Expected: Switched to branch 'main'.

**Step 6: Delete the temporary reset branch**
Run: `git branch -D reset-main`
Expected: Deleted branch reset-main.

**Step 7: Verify final state**
Run: `git log --oneline && git status`
Expected: Only one commit "init" and a clean working directory.

### Task 2: Final Cleanup

**Files:**
- Modify: `CHANGELOG.md`
- Modify: `.claude-plugin/plugin.json`
- Modify: `VERSION`

**Step 1: Verify version consistency**
Check that all version files match 1.0.0.
Run: `grep "1.0.0" .claude-plugin/plugin.json VERSION CHANGELOG.md`
Expected: Matches found in all files.

**Step 2: Commit any final tweaks (if needed)**
If any tweaks were missed during the orphan branch creation, commit them now.
Run: `git commit --amend --no-edit`
Expected: Initial commit updated.

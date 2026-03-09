# Execution Phases

Work through phases E1 → E5 in order.

---

## Phase E1 — Blueprint Load & Sanity Check

Load the blueprint from the **project cache**. Blueprint path:

`~/.claude/plugins/local/faah/cache/<project-key>/blueprints/<date>-<feature>/`

**Project key:** From CWD — strip leading `/`, replace `/` with `-`, lowercase (see `faah-project-cache`).

Load in this order:

1. `README.md` — orientation
2. `requirements.md` — confirmed requirements
3. `affected-files.md` — full change surface
4. `implementation-sequence.md` — task order

If multiple blueprint folders exist, ask the user which one to execute before loading anything.

### Sanity Check

For every file listed in `affected-files.md`, verify the named anchor still exists in the codebase:

- For **Modify** actions: check that the referenced function, export, variable, or class is present in the file
- For **Create** actions: check that the target directory exists and no conflicting file already exists at that path

Present findings:

```
## Blueprint Sanity Check

**Blueprint:** (project cache) `cache/<project-key>/blueprints/<date>-<feature>/`
**Tasks:** N tasks across N groups

**Anchor verification:**
✅ src/stores/user.store.ts — export `useUserStore` found
✅ app/dashboard/page.tsx — component `DashboardPage` found
⚠️  src/api/root.ts — function `createRouter` not found (file may have been renamed)

**Drift detected:** [list each discrepancy with the file and anchor that could not be verified]
```

If drift is detected: stop. Present every discrepancy and ask user to confirm or correct before proceeding. Do not proceed past E1 with unresolved drift.

If clean: present a brief execution summary and wait for explicit go-ahead:

```
Blueprint is clean. No drift detected.

Ready to execute:
- N task groups
- Files to create: N
- Files to modify: N

Confirm to proceed to workspace setup.
```

---

## Phase E2 — Workspace Setup

### Git Worktree

**Use the FAAH `faah-worktrees` skill.** Load and follow it exactly:

1. Read `skills/faah-worktrees/SKILL.md` (or the plugin-resolved path).
2. Announce: "I'm using the faah-worktrees skill to set up an isolated workspace."
3. Follow the skill's directory selection, safety verification, creation steps, project setup, and baseline verification.
4. **Branch name:** Derive from the feature name in `requirements.md`: use `feature/<feature-name>` (e.g. `feature/auth`, `feature/dashboard`). Pass this as `BRANCH_NAME` when creating the worktree.

**Blueprint-specific report after worktree is ready:**

```
Worktree ready at <full-path>
Branch: feature/<feature-name>
Baseline: N tests passing, 0 failures
Ready to execute.
```

If the worktree skill asks the user (e.g. directory choice), resolve that before continuing. Do not proceed to E3 until the worktree is ready and baseline tests pass.

---

## Phase E3 — Task Execution

### Setup

Create a TodoWrite from every task in `implementation-sequence.md`. Group the tasks exactly as the sequence defines them — do not reorder.

### Execution Loop

Work through one task group at a time.

**Per task:**

1. Mark task `in_progress` in TodoWrite
2. Load the relevant investigation file for this task's domain:
   - Types / API task → pull `investigation/api.md`
   - State / store task → pull `investigation/state.md`
   - Component task → pull `investigation/components.md`
   - Route / navigation task → pull `investigation/routing.md`
3. Implement exactly what `affected-files.md` specifies for this file — no more, no less
4. Run the verification specified in `implementation-sequence.md` for this task
5. Dispatch reviewer agent — see Phase E4
6. If reviewer approves: mark task `completed`, commit
7. If reviewer finds issues: fix, re-run verification, re-review, then mark complete

**Commit discipline:**

- One commit per completed task
- Message format: `feat(<feature-name>): <task description>`

### After Each Group Completes

Report to the user:

```
## Group Complete: [Group Name]

Tasks completed:
- [x] Task N — [description] (verified)
- [x] Task N — [description] (verified)

Verification output:
[paste actual test/lint output]

Next group: [Group Name] — [N tasks]
Confirm to proceed.
```

Wait for explicit confirmation before the next group.

### Stop When Blocked

Stop immediately and surface the issue if:

- An instruction in the blueprint does not match the actual codebase state
- A verification fails repeatedly and the cause is not clear
- An implementation decision is required that the blueprint does not specify

Do not guess. Do not work around a blocker silently. Report the exact blocker and wait.

---

## Phase E4 — Per-Task Review

After each task, dispatch the **blueprint-reviewer** agent (`agents/blueprint-reviewer.md`) using the brief template in `reviewer-prompt.md`.

**Brief the reviewer with:**

- The `affected-files.md` entry for this specific file (paste it in full)
- The git diff for this file since the task started:
  ```bash
  git diff HEAD~1 -- <file-path>
  ```

**The reviewer answers one question:** Does the implementation match what `affected-files.md` specified for this file — the action (create/modify), the anchor, and the change description?

**Reviewer output:**

- ✅ Approved — proceed
- ❌ Issues found — list each gap precisely

**If issues found:**

- Fix the gap
- Re-run verification
- Re-review (same reviewer prompt, updated diff)
- Do not proceed to the next task until approved

The reviewer checks spec compliance only — not general code quality, naming preferences, or anything beyond what the blueprint specified.

---

## Phase E5 — Completion

### Final Verification

After all task groups complete, run the full test suite:

```bash
npm test  # or project-appropriate command
```

Do not claim completion without running this and reading the output. If tests fail: fix before proceeding. Do not present completion options with a failing suite.

### Finish the Branch

Present exactly these four options:

```
Implementation complete. All N tasks done, tests passing.

What would you like to do?

1. Merge back to <base-branch> locally
2. Push and create a Pull Request
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Option 1 — Merge locally:**

```bash
git checkout <base-branch>
git pull
git merge feature/<feature-name>
<run tests again on merged result>
git branch -d feature/<feature-name>
git worktree remove .worktrees/<feature-name>
```

**Option 2 — Push and PR:**

```bash
git push -u origin feature/<feature-name>
gh pr create --title "<feature-name>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets derived from requirements.md>

## Blueprint
(project cache) cache/<project-key>/blueprints/<date>-<feature-name>/

## Test Plan
- [ ] All existing tests pass
- [ ] <key verification steps from implementation-sequence.md>
EOF
)"
```

Keep worktree until PR is merged.

**Option 3 — Keep as-is:**
Report branch and worktree location. No cleanup.

**Option 4 — Discard:**
Confirm first:

```
This will permanently delete:
- Branch feature/<feature-name>
- All commits on this branch
- Worktree at .worktrees/<feature-name>

Type 'discard' to confirm.
```

Wait for exact typed confirmation before proceeding.

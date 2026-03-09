---
description: Execute a blueprint from the project cache in an isolated worktree with per-task review
disable-model-invocation: true
---

Invoke the FAAH **faah-execute-blueprint** skill and follow it exactly. That skill loads the blueprint from the project cache (`cache/<project-key>/blueprints/`), runs workspace setup (using the **faah-worktrees** skill), and executes the implementation sequence in batches with per-task review.

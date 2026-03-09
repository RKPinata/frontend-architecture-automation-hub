---
name: faah-feature-blueprint
description: Use when you need to investigate a feature via agents and produce a structured blueprint folder for a future execution session.
---

# Frontend Architecture Automation Hub— Feature Blueprint

You are operating in **blueprint mode**. Your job is to produce a complete, structured blueprint that an executor agent can pick up in a new session and implement without ambiguity.

**You do not write code. You do not modify source files. You only write blueprint documents.**

Work through phases B0 → B5 in order. See [references/blueprinting-phases.md](./references/blueprinting-phases.md) for detailed phase instructions.

---

## Output Structure

See [references/blueprint-structure.md](./references/blueprint-structure.md) for the detailed blueprint folder structure and path rules.

---

## Rules

- **Check project cache first** — skip codebase scan if cache hit; only investigate on cache miss
- **Check for in-progress blueprint** — always offer resume before starting fresh (Phase B0)
- **Blueprints live in the project cache** — never write to `docs/blueprints/` or any path inside the git repo
- **Fresh context per agent** — each agent receives only the cache sections relevant to its domain
- **Read-only during investigation** — no project source files are modified until execution
- **Write blueprint files incrementally** — each file is written as its phase completes, not all at the end
- **Write .progress after every phase** — enables session resume
- **Agents receive targeted context** — paste only relevant cache sections + full requirements.md; never paste full context.md
- **Scale agents to the feature** — add or remove investigation agents based on what the feature actually touches
- **Exact file paths always** — every file reference uses the actual path discovered during investigation
- **No execution** — this skill ends with a complete blueprint folder in the cache, never with implemented code

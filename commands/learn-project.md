---
description: Scan the project and build the FAAH project cache
allowed-tools: "Read, Write, Glob, Bash(pwd:*), Bash(mkdir:*), Bash(date:*), Bash(test:*), Agent"
---

You are running the **faah-learn-project** workflow. Your job is to investigate the current project, build a persistent project context cache, and then instruct the user to clear the context.

**CRITICAL — Cache location rule:**
All project cache files MUST be written to `${CLAUDE_PLUGIN_ROOT}/cache/<project-key>/`.
NEVER write to `~/.claude/projects/*/memory/` — that is the Claude auto-memory directory and is not for project caches.

---

## Step 1 — Determine project key and cache path

Run: !`pwd`

Compute the project key using the shared utility:
!`source "${CLAUDE_PLUGIN_ROOT}/scripts/faah-utils.sh" && derive_project_key "$(pwd)"`

If the utility is missing, use this fallback:
- Take the path output, strip the leading `/`, replace `/` with `-`, lowercase everything.
- Example: `/path/to/my-project` → `path-to-my-project`

Cache file path: `${CLAUDE_PLUGIN_ROOT}/cache/<project-key>/project-context.md`

## Step 2 — Check for existing cache

Check if the cache file already exists:
!`source "${CLAUDE_PLUGIN_ROOT}/scripts/faah-utils.sh" && test -f "${CLAUDE_PLUGIN_ROOT}/cache/$(derive_project_key "$(pwd)")/project-context.md" && echo "EXISTS" || echo "MISSING"`

If **EXISTS**, present:

```
Project cache already exists for this project.
Cached: [read the **Cached:** line from the file]

Options:
R) Refresh — re-scan and overwrite the cache
S) Skip — cache is already up to date

Choose R or S.
```

Wait for the user's choice:

- **S (Skip):** Jump to Step 5 — present completion and instruct `/clear`.
- **R (Refresh):** Continue to Step 3.

If **MISSING**, continue to Step 3.

## Step 3 — Dispatch investigation agent

Load the investigation brief template: @${CLAUDE_PLUGIN_ROOT}/skills/faah-feature-blueprint/investigator-prompt.md

Dispatch a **full project scan agent** using the Agent tool. Brief it using the "Full Project Scan Agent Checklist" from the investigator prompt template.

Agent brief:

```
You are an investigation agent. Your job is to read and analyse the project — you do not write code, modify project files, or make commits.

## Your scope
Full project scan — produce a complete project-context.md covering all cache sections.

## Files to examine (in order)
1. package.json — framework, major deps, scripts
2. Top-level src/ directory listing
3. src/app/ directory listing (if it exists)
4. src/app/modules/ directory listing — feature module structure
5. One representative feature module — full subfolder structure
6. One component from that module — template, script, styling conventions
7. One Pinia/Vuex store — structure, exports, state pattern
8. One composable — lifecycle, cleanup pattern
9. One query/data-fetching file — query + mutation pattern, key conventions
10. Router configuration file — route structure, guards, lazy loading
11. One test file — testing library, file location
12. jsconfig.json or vite.config.js — path aliases

## Output format
Return your findings as a structured markdown document using EXACTLY this format:

---
# Project Context Cache
**Project:** [name from package.json]
**Path:** [current working directory]
**Cached:** [today's date YYYY-MM-DD]
**Cache version:** 1

---

## Stack
[framework, state, routing, styling, testing, language, build, package manager]

---

## Folder Structure
[tree with one-line descriptions]

---

## Component Patterns
[naming, file organisation, prop patterns, template conventions]

---

## State Patterns
[store structure, composable pattern, query pattern, flow direction rules, thin store rules]

---

## Routing Patterns
[route registration, layout composition, auth guard location and pattern]

---

## Data Fetching Patterns
[query hook structure, mutation pattern, query key conventions, service layer]

---

## File Naming
[conventions for components, composables, utilities, folders with examples]

---

## Key Conventions
[import order, path aliases, styling rules, i18n usage, ESLint highlights]

---

## Notes
[legacy code warnings, deviations from primary pattern, anything unusual]
---

Constraint: Read-only. Do not modify any project source file.
```

Wait for the agent to return its findings.

## Step 4 — Save to cache

Create the cache directory:
!`source "${CLAUDE_PLUGIN_ROOT}/scripts/faah-utils.sh" && mkdir -p "${CLAUDE_PLUGIN_ROOT}/cache/$(derive_project_key "$(pwd)")"`

Write the agent's output as the cache file at:
`${CLAUDE_PLUGIN_ROOT}/cache/<project-key>/project-context.md`

Confirm the write succeeded.

## Step 5 — Completion

Present:

```
Project cache saved.

Location: ~/.claude/plugins/local/faah/cache/<project-key>/project-context.md

The FAAH skills (faah-feature-scope, faah-feature-blueprint) will now load this cache
instead of re-investigating the project on every session.

To refresh: run /learn-project again.

---

Context is now loaded with project investigation data. Run /clear to start a fresh session —
the next faah- command will automatically load the cache with a clean context.
```

**Final instruction to the user:** Output exactly this line as your last message:

> Run `/clear` to start a fresh session. The project cache has been saved and will be loaded automatically.

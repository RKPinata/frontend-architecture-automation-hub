# Blueprinting Phases

Work through phases B0 → B5 in order.

---

## Phase B0 — Session Resume Check

Before doing anything, check for an in-progress blueprint.

1. Compute the project key from CWD (see `faah-project-cache`).
2. Look for `~/.claude/plugins/local/faah/cache/<project-key>/blueprints/`.
3. Find any blueprint folder that contains a `.progress` file with `status: in_progress`.
4. If found, present:

```
## In-Progress Blueprint Found

Blueprint: blueprints/<date>-<feature-name>/  (in project cache)
Last phase completed: [read from .progress]
Progress:
  ✅ B1 — Context
  ✅ B2 — Requirements
  ⬜ B3 — Investigation Plan
  ⬜ B4 — Parallel Investigation
  ⬜ B5 — Blueprint Documents

Resume this blueprint, or start fresh?

R) Resume from [next phase]
N) Start a new blueprint
```

Wait for the user to choose before proceeding.

- **Resume:** Skip completed phases, load their output files, continue from the next phase.
- **New:** Proceed with Phase B1.

---

## Phase B1 — Context

Before asking the user anything, load project context. Run silently.

### Step 1 — Load Project Cache

**Use `faah-project-cache` skill.** Call Load Cache operation.

- **CACHE_HIT:** Skip codebase scan. Use cached context as `context.md` content. Present it to the user. Go to Step 3.
- **CACHE_MISS:** Proceed to Step 2 (dispatch context agent).

### Step 2 — Context Agent (cache miss only)

Dispatch a **context agent** with a brief based on `investigator-prompt.md`.

Brief the context agent:

- Scope: full project scan (package.json, folder structure, representative component, store, composable, data fetching pattern, routing, types, test file)
- Goal: return a structured project pattern summary covering all sections of the project cache format
- Output: write findings to the blueprint folder in the project cache (e.g. `cache/<project-key>/blueprints/<date>-<feature>/context.md`)
- Constraint: read-only — no file modifications

Wait for the context agent to complete.

After the agent returns, **save findings to project cache** using `faah-project-cache` Save Cache operation.

### Step 3 — Present & Confirm

Present the `context.md` summary to the user:

```
## Project Context

[paste context.md summary — or cache summary if cache hit]

Does this accurately reflect the project? Confirm or correct before I proceed to requirements.
```

Wait for confirmation. If the user corrects anything, update both `context.md` and the project cache.

**Write `.progress`:**

```
phase: B1
status: complete
last_updated: YYYY-MM-DD
```

---

## Phase B2 — Requirement Intake

Analyse what you already know before asking anything:

- What has the user already stated? (feature name, intent, scope hints)
- What does `context.md` already reveal? (existing routes, auth patterns, data domains already in the store)

Derive what is **already known** and what is **genuinely unknown**. Only ask about what you cannot determine from existing context.

**Questions to ask only if unresolved:**

| Question      | Ask if                                                  |
| ------------- | ------------------------------------------------------- |
| Feature name  | Not stated                                              |
| User story    | Intent is unclear or ambiguous                          |
| Data involved | No obvious data domain mentioned or inferable           |
| Entry points  | Cannot be determined from existing routes in context.md |
| Dependencies  | Auth/store dependencies not evident from context.md     |
| Scope         | Cross-route impact is ambiguous                         |
| Backend       | API status unknown and feature clearly requires data    |

**Format when questions remain:**

```
Based on the project context, I can already determine:
- [what you know and how you know it]

I need clarification on:
1. [only genuinely unresolved question]
```

**Format when context is sufficient:**

```
Based on your request and the project context, I understand the feature as follows:
[clear summary]

Is this correct before I proceed to investigation planning?
```

After answers, write `requirements.md` immediately.

### Scope / Complexity Check

Before Phase B3, check whether the feature was pre-scoped by `faah-feature-scope`:

- If the user provides a scope map / chunk plan from F2.5: load it, write it to `scope.md`, and use chunks to drive the investigation plan.
- If no scope map: perform a quick complexity estimate inline (Low / Medium / High / Epic) and surface it:

```
**Complexity estimate:** High — touches components, state, routing, and API layers, ~20 files.
**Blueprint approach:** I will investigate each domain separately and produce chunk-based implementation sequences.
```

Write `.progress`:

```
phase: B2
status: complete
```

---

## Phase B3 — Investigation Plan

Based on context + confirmed requirements, produce an investigation to-do list. Present it before dispatching any agents.

**Scale agents to the actual feature — do not add agents for domains the feature does not touch.**

```
## Investigation Plan

I will dispatch the following investigation agents:

**Agent 1 — Components**
- Scope: [specific components, modules, or patterns to examine]
- Questions to answer: [what integration points, prop patterns, slot usage to verify]
- Context sections I will provide: Stack, Component Patterns, File Naming
- Output file: `blueprints/<date>-<feature>/investigation/components.md` (in project cache)

**Agent 2 — State**
- Scope: [specific Pinia stores, composables to examine]
- Questions to answer: [what state already exists, what new state is needed, composable vs store boundary]
- Context sections I will provide: Stack, State Patterns, Key Conventions
- Output file: `blueprints/<date>-<feature>/investigation/state.md` (in project cache)

**Agent 3 — Routing**
- Scope: [specific route files, navigation components, guards]
- Questions to answer: [how routes are registered, where nav items are added, auth guard pattern]
- Context sections I will provide: Stack, Routing Patterns, Folder Structure
- Output file: `blueprints/<date>-<feature>/investigation/routing.md` (in project cache)

**Agent 4 — API / Data**
- Scope: [specific query files, service files, API endpoints]
- Questions to answer: [existing query patterns, how to register new endpoints, query key conventions]
- Context sections I will provide: Stack, Data Fetching Patterns, Key Conventions
- Output file: `blueprints/<date>-<feature>/investigation/api.md` (in project cache)

Confirm to dispatch all agents.
```

Wait for confirmation before Phase B4.

Write `.progress`:

```
phase: B3
status: complete
agents_planned: [list agent domains]
```

---

## Phase B4 — Parallel Investigation

Dispatch all investigation agents in parallel.

**REQUIRED SUB-SKILL:** Use `investigator-prompt.md` as the agent brief template for each agent.

**Fresh context rule:** Each agent receives only the cache sections relevant to its domain — not the full context. See `faah-project-cache` Section Extraction table.

Each agent must:

- Receive only its relevant context sections from the project cache (not the full context.md)
- Receive the full `requirements.md` content
- Have a specific, narrow scope — one domain only
- Be read-only — no file modifications to project source files
- Write its findings directly to its assigned output file in the project cache

**Agent brief structure (per agent):**

```
[Context: paste ONLY the relevant cache sections for this agent's domain]
[Requirements: paste requirements.md content in full]

Your scope: [specific domain]
Your goal: [specific questions to answer]
Write your findings to: ~/.claude/plugins/local/faah/cache/<project-key>/blueprints/<date>-<feature>/investigation/<domain>.md

Findings format — see investigator-prompt.md for the required structure.

Constraint: Read-only. Do not modify any project source file.
```

Wait for all agents to complete before Phase B5.

After all agents return, present a one-line summary of each agent's findings:

```
All investigation agents complete:
- Components: [one-line finding]
- State: [one-line finding]
- Routing: [one-line finding]
- API: [one-line finding]

Proceeding to blueprint document generation.
```

Write `.progress`:

```
phase: B4
status: complete
agents_completed: [list]
```

---

## Phase B5 — Blueprint Documents

With all investigation files written, produce the remaining documents.

### scope.md (if feature was split into chunks)

```markdown
# Scope: [Feature Name]

**Complexity:** [Low / Medium / High / Epic]
**Reason:** [brief explanation]

## Chunks

| #   | Chunk        | Domains   | Depends On | Can Run Parallel |
| --- | ------------ | --------- | ---------- | ---------------- |
| 1   | [chunk name] | [domains] | —          | No               |
| ... |              |           |            |                  |

## Execution Groups

- **Group 1 (sequential):** 1 → 2 → 3
- **Group 2 (parallel):** 4a, 4b
- **Group 3 (sequential):** 5

## Executor instruction

Work through groups in order. Within a group marked parallel, dispatch tasks concurrently.
```

### affected-files.md

For every file that needs to change:

```markdown
## src/app/modules/[name]/components/[Name].vue

**Action:** Create
**Why:** New feature component — data owner for [feature]
**Key content:** [2–3 sentences on what this file must contain]

## src/store/[name]Store.js

**Action:** Modify
**Anchor:** export `use[Name]Store` — Pinia store definition
**Why:** Add [feature] state to global store
**Change needed:** [precise description — no code]
**Rule:** Thin store only — state and computed; no watchers, lifecycle, or useQuery inside
**Risk:** Low — additive change, no existing behaviour affected

## src/router/index.js

**Action:** Modify
**Anchor:** `routes` array — [route near the new one]
**Why:** Register feature route
**Change needed:** [precise description]
**Risk:** Low
```

Include every file — new and modified. No file should be a surprise to the executor.

### implementation-sequence.md

Produce an ordered task list. For chunked features, one sequence per execution group with a clear group header.

```markdown
# Implementation Sequence: [Feature Name]

> **For executor agent:** Load `README.md` for orientation, `affected-files.md` for file references, and this file to begin execution. Pull `investigation/<domain>.md` files for deeper context per domain.

---

## Group 1 — Foundation (sequential)

### Task 1 — Types / Constants

- [ ] Create `src/app/modules/[name]/constants/[name].constants.js`
- [ ] Define: [list constants or type definitions] — see requirements.md for definitions

### Task 2 — API Layer

- [ ] Create `src/app/queries/use[Name].js`
- [ ] Implement: [list each query and mutation] — follow pattern in investigation/api.md
- [ ] Query key convention: [from investigation/api.md]

### Task 3 — Store (if needed)

- [ ] Create or modify `src/store/[name]Store.js`
- [ ] Thin store only: state + computed — follow pattern in investigation/state.md

### Task 4 — Composable

- [ ] Create `src/app/modules/[name]/composables/Use[Name].js`
- [ ] Handles: lifecycle, watchers, side effects, bridge to store
- [ ] Cleanup: onScopeDispose() — see investigation/state.md for existing pattern

---

## Group 2 — Components (parallelisable)

|> These tasks can run concurrently.

### Task 5 — [FeatureName].vue (data owner)

- [ ] Create component, use Use[Name] composable
- [ ] See investigation/components.md for template and prop patterns

### Task 6 — [FeatureName]List.vue

- [ ] Consumer component — receives items as props or reads from composable
      ...

---

## Group 3 — Integration (sequential)

### Task 7 — Route Integration

- [ ] Modify `src/router/index.js` — see investigation/routing.md line reference
- [ ] Apply auth guard: [guard name and file]

### Task 8 — Navigation

- [ ] Add nav entry to `[NavigationComponent]` — see investigation/routing.md line reference

### Task 9 — i18n

- [ ] Add keys to `src/locales/en/[namespace].json` — append to bottom
- [ ] Keys: [list new i18n keys]

### Task 10 — Tests

- [ ] Unit: `Use[Name].js` composable
- [ ] Component: `[Name]Form.vue`
- [ ] Integration: create → list flow
```

### README.md

Write last, after all other files are complete:

```markdown
# Blueprint: [Feature Name]

**Date:** YYYY-MM-DD
**Project:** [project name]
**Complexity:** [Low / Medium / High / Epic]
**Status:** Ready for execution

## What this blueprint contains

| File                        | Purpose                                                      |
| --------------------------- | ------------------------------------------------------------ |
| context.md                  | Project patterns — stack, conventions, folder rules          |
| requirements.md             | Confirmed feature requirements                               |
| scope.md                    | Complexity rating and chunk/group plan (if split)            |
| investigation/components.md | Component layer findings                                     |
| investigation/state.md      | State management findings                                    |
| investigation/routing.md    | Routing and navigation findings                              |
| investigation/api.md        | API and data fetching findings                               |
| affected-files.md           | Every file that needs to change, with location and rationale |
| implementation-sequence.md  | Ordered task list for execution                              |

## How to use this blueprint

Open a new session and load this blueprint:

1. Read `README.md` (this file) for orientation
2. Read `scope.md` to understand chunk boundaries (if split)
3. Read `affected-files.md` to understand the full change surface
4. Read `implementation-sequence.md` to begin execution
5. Pull `investigation/<domain>.md` files for deeper context

## Feature summary

[2–3 sentence summary of the feature, its purpose, and the implementation approach]
```

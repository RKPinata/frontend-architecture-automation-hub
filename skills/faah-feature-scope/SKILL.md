---
name: faah-feature-scope
description: Use when adding a feature to an existing codebase to produce an implementation plan consistent with current project patterns.
---

# Frontend Architecture Automation Hub— Feature Scope

You are operating in **feature scope**. Your job is to produce a feature implementation plan that is fully consistent with the existing project's patterns. You do not impose new conventions. Every recommendation must be anchored to what is already in the codebase.

Work through phases F1 → F5 in order.

---

## Phase F1 — Project Context

Before asking the user anything, load the project context. Run silently.

### Step 1 — Load Project Cache

**Use `faah-project-cache` skill.** Call Load Cache operation.

- If `CACHE_HIT`: use the cached context. Present the stack summary to the user and skip Step 2.
- If `CACHE_MISS`: proceed to Step 2.

### Step 2 — Analyse the Codebase (cache miss only)

Read the following, in order:

1. `package.json` — identify framework, meta-framework, state libraries, data fetching libraries, styling approach, test setup
2. Top-level `src/` or `app/` directory listing — identify folder conventions
3. 2–3 representative component files — note file naming, prop patterns, state consumption, hook colocation
4. One store file (Pinia store / Vuex store / Zustand slice) — extract the store pattern
5. One data fetching example (TanStack Query hook / composable) — extract the abstraction pattern
6. Routing structure — file-based vs config-based, layout composition, route param handling
7. One types or constants file — understand how types/constants are structured
8. One test file (if present) — note testing library and file colocation pattern

After analysis, **save to project cache** using `faah-project-cache` Save Cache operation.

### Step 3 — Present Project Pattern Summary

Present findings and wait for confirmation before proceeding:

```
## Project Pattern Summary

**Stack detected:**
- Framework: [e.g. Vue 3 + Vite 7]
- Styling: [e.g. TailwindCSS — all utilities prefixed with a project-specific prefix]
- State: [e.g. Pinia for global state, TanStack Query for server state]
- Data fetching: [e.g. TanStack Query via composables in src/app/queries/]
- Language: [e.g. JavaScript with JSDoc]

**Structural conventions:**
- Modules: [e.g. src/app/modules/[feature]/ — each module owns its components, composables, stores]
- Components: [e.g. PascalCase .vue files, max 1 attribute per line in templates]
- Composables: [e.g. Use* naming, must live in **/composables/ directories]
- Stores: [e.g. thin Pinia stores — no lifecycle hooks, watchers, or timers inside stores]
- Queries: [e.g. src/app/queries/ — TanStack Query hooks, never called inside stores]

**Naming conventions:**
- Components: [e.g. PascalCase, named exports]
- Composables: [e.g. UseFeatureName.js, must start with Use]
- Folders: [e.g. kebab-case]

**Key patterns observed:**
- [Pattern 1]
- [Pattern 2]
- [Pattern 3]

Does this accurately reflect the project? Confirm or correct before I proceed.
```

Wait for confirmation. If the user corrects something, update the cache.

---

## Phase F2 — Feature Intake

With the project patterns confirmed, ask in two parts. Send both blocks together. Wait for all answers before proceeding.

**Part A — Feature description:**

```
Describe the feature you want to architect:

1. **Feature name**: What is this feature called?
2. **User story**: What does the user do, and what do they see? (1–3 sentences)
3. **Data involved**: What data does this feature create, read, update, or delete?
4. **Entry points**: Where does the user access this feature from? (Which existing pages/routes?)
5. **Dependencies**: Does this feature depend on existing data or state? (e.g. requires auth, reads from user store)
6. **Scope**: Isolated to one page/route, or does it surface across multiple parts of the app?
7. **Backend**: Is the backend API already defined? If yes, what endpoints/procedures are available?
```

**Part B — Additional context (optional but recommended):**

```
Do you have any of the following?

1. **Figma**: Share a Figma link — I will read the design to extract component structure, layout, and states.
2. **Notion / docs**: Share a Notion page URL or paste the content directly (PRD, spec, API contract).
3. **Other**: Any Slack threads, screenshots, API schemas, or written notes.

If you have none, describe in words — I will work from that.
```

### Handling provided context

**If a Figma link is provided:**

- Use the Figma MCP (`get_design_context`) to read the design
- Extract: component breakdown, layout structure, interactive states, annotated behaviour
- Note any design tokens or component names that should be reflected in the implementation

**If a Notion link or doc is provided:**

- Extract: feature requirements, user stories, acceptance criteria, API contracts, edge cases, out-of-scope items
- Flag requirements with architectural implications not yet covered

After processing all context, confirm understanding in one paragraph before Phase F2.5.

---

## Phase F2.5 — Complexity & Scope Analysis

See [references/complexity-matrix.md](./references/complexity-matrix.md) for the complexity rating criteria, scope checks, and chunk planning rules.

---

## Phase F3 — Feature Architecture

Produce the full feature specification. Every output must reference the existing project pattern.

For split features, produce one architecture per confirmed chunk — not one monolithic architecture.

### F3a. Feature Structure

Define where the feature's files live, using the project's folder conventions exactly.

```
src/app/modules/[feature-name]/
├── components/
│   ├── [FeatureName].vue
│   ├── [FeatureName]List.vue
│   └── [FeatureName]Form.vue
├── composables/
│   └── Use[FeatureName].js
└── [FeatureName]Store.js     (only if global state is needed — thin store only)
```

Adjust to match the project's actual conventions. Document any unavoidable deviation and justify it.

### F3b. Integration Points

| Integration Point | Existing File/Module                | Change Required                   | Risk   |
| ----------------- | ----------------------------------- | --------------------------------- | ------ |
| Route entry       | `src/router/index.js`               | Add new route                     | Low    |
| Navigation        | `src/app/components/NavSidebar.vue` | Add nav item                      | Low    |
| Auth guard        | `src/router/guards.js`              | Verify feature is gated correctly | Medium |
| Existing store    | `src/store/[domain]Store.js`        | Read [value] for API calls        | None   |
| API layer         | `src/app/queries/[domain].js`       | Add new query hook                | Low    |

Reference actual file paths discovered in Phase F1.

### F3c. State Additions

| State                | Category       | Implementation                                  | Rationale                                      |
| -------------------- | -------------- | ----------------------------------------------- | ---------------------------------------------- |
| [feature].items      | Server State   | TanStack Query `useQuery` in `src/app/queries/` | Follows existing pattern in [existing-feature] |
| [feature].selectedId | Local UI State | `ref()` in [FeatureName].vue                    | Ephemeral — no cross-feature dependency        |

**Store rule:** If global state is needed, the store is thin (state + computed only — no watchers, no lifecycle, no queries). Lifecycle-aware logic goes in the composable.

### F3d. Data Flow

```
[API / Server]
  → [Query hook: src/app/queries/use[Feature].js]
  → [Composable: Use[Feature].js — lifecycle, watchers, side effects]
  → [Feature component: data owner]
  → [Child components: consumers]
  → [UI output]

Mutations:
[User action]
  → [Mutation in Use[Feature].js]
  → [API call → cache invalidation or store update]
  → [UI reflects change]
```

### F3e. State Influence Map

For every piece of new state this feature introduces:

```
STATE: [feature].items
  CHANGES WHEN: [triggers]
  INFLUENCES:
    - [Component]: [effect]
  SIDE EFFECTS:
    - [effect or "None"]
```

---

## Phase F4 — Implementation Checklist

Produce an ordered, executable checklist. For split features, one checklist per chunk.

```
## Feature Implementation Plan: [Feature Name] [— Chunk N if split]

### 1. Types / Constants
- [ ] Create src/app/modules/[name]/constants/[name].constants.js
- [ ] Define [constants, enums, or types needed]

### 2. API / Query Layer
- [ ] Create src/app/queries/use[Name].js
- [ ] Implement: [list each query and mutation]
- [ ] Follow query key convention from existing queries

### 3. Store (if needed)
- [ ] Create src/store/[name]Store.js (thin — state + computed only)
- [ ] No watchers, lifecycle hooks, or useQuery calls inside the store

### 4. Composable
- [ ] Create src/app/modules/[name]/composables/Use[Name].js
- [ ] Composable handles: lifecycle, watchers, side effects, bridge to store
- [ ] Cleanup with onScopeDispose()

### 5. Components
- [ ] [FeatureName].vue — data owner, uses Use[Name] composable
- [ ] [FeatureName]List.vue — consumer
- [ ] [FeatureName]Form.vue — mutation trigger

### 6. Route Integration
- [ ] Add route to src/router/index.js
- [ ] Apply existing auth guard from [guard file]

### 7. Navigation
- [ ] Add nav entry to [component]

### 8. i18n
- [ ] Add keys to src/locales/en/[namespace].json (append to bottom)
- [ ] Namespace: [confirm with user]

### 9. Tests
- [ ] Unit: Use[Name].js composable
- [ ] Component: [FeatureName]Form.vue
- [ ] Integration: create → list flow
```

---

## Phase F4.5 — Save Scope to Cache

After the implementation checklist is confirmed, save the feature scope document to the project cache.

**Path:** `~/.claude/plugins/local/faah/cache/<project-key>/feature-scopes/YYYY-MM-DD-<feature-name>.md`

**Format:**

```markdown
# Feature Scope: [Feature Name]

**Date:** YYYY-MM-DD
**Complexity:** [Low / Medium / High / Epic]
**Status:** scoped

## Summary

[2–3 sentence description of the feature]

## Chunks (if split)

[chunk table from F2.5, or "Single unit — no split required"]

## Architecture

[paste F3a–F3e output]

## Implementation Checklist

[paste F4 checklist]
```

Append to `~/.claude/plugins/local/faah/cache/<project-key>/feature-scopes/index.md` (create if missing):

```markdown
## YYYY-MM-DD-<feature-name>

**Complexity:** [Low / Medium / High / Epic]
**Summary:** [one-sentence description]
**Path:** feature-scopes/YYYY-MM-DD-<feature-name>.md
```

Confirm: `Feature scope saved to project cache.`

---

## Phase F5 — Design Sub-skill

Ask:

```
Architecture for [feature name] is complete. Shall I design the UI components?

I will produce visual implementation for [list components], scoped to the project's detected stack and CSS approach, consistent with the existing design patterns observed in this project.
```

If confirmed, invoke **faah-design** with:

- Detected stack and CSS approach (TailwindCSS with project-specific prefix)
- Existing component visual patterns from Phase F1
- The specific components to design

---

## Rules

- Always check project cache before investigating the codebase
- Every recommendation must reference the existing project pattern
- Never impose a new convention without explicit justification and user approval
- For High/Epic features, always surface the scope split before producing architecture
- The chunk plan from F2.5 drives the blueprint structure — smaller chunks = more accurate blueprints
- Store rule: Pinia stores are thin — state + computed only; composables handle lifecycle and side effects
- Use Context7 to pull current docs for any library whose pattern you are extending

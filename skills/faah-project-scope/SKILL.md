---
name: faah-project-scope
description: Use when starting a new frontend project from scratch to establish stack, structure, and architectural foundations.
---

# Frontend Architecture Automation Hub— Project Scope

You are operating in **project scope**. Your job is to establish the full architectural foundation for a new frontend project. You produce decisions, documentation, and structure. Code comes last.

Work through phases 1 → 4 in order. Do not skip phases. Wait for user input at each phase before proceeding.

---

## Phase 1 — Stack Intake

Ask all questions at once. Wait for answers before proceeding.

```
To architect the frontend correctly, I need to understand your constraints and preferences:

1. **Framework**: React, Vue, Svelte, Angular, Solid, or other?
2. **Meta-framework**: Next.js, Nuxt, SvelteKit, Astro, Remix, TanStack Start, Vite SPA, or other?
3. **Styling approach**: Tailwind CSS, CSS Modules, Styled Components, vanilla CSS, UnoCSS, or other?
4. **State management**: What data needs global state vs. local? (e.g. auth, user prefs, server cache, UI state)
5. **Data fetching**: REST, GraphQL, tRPC, or direct server functions?
6. **Project type**: Dashboard, SaaS app, marketing site, e-commerce, design system, or other?
7. **Scale**: MVP / prototype, growth-stage product, or enterprise?
8. **Team**: Solo, small team (2–5), or larger? Frontend-only or full-stack?
9. **Existing constraints**: Design system, backend, or third-party integrations to accommodate?
10. **Auth**: Client-side auth, server sessions, or no auth?
```

Confirm the stack in a brief summary before Phase 2.

---

## Phase 2 — Architecture Design

Produce the following. Scope everything to the chosen framework and meta-framework — no generic advice.

### 2a. Project Structure

Generate a directory tree. For each top-level directory, include a one-line description of what belongs there and what does not.

Scoping rules:

- **Next.js App Router**: `app/`, `components/`, `lib/`, `hooks/`, `stores/`, `types/`, `styles/`
- **Next.js Pages Router**: `pages/`, `components/`, `lib/`, `hooks/`, `stores/`, `types/`
- **SvelteKit**: `src/routes/`, `src/lib/`, `src/lib/components/`, `src/lib/stores/`
- **Nuxt**: `pages/`, `components/`, `composables/`, `stores/`, `utils/`
- **Astro**: `src/pages/`, `src/components/`, `src/layouts/`, `src/content/`
- **Vite SPA**: `src/pages/`, `src/components/`, `src/hooks/`, `src/stores/`, `src/api/`

Include naming conventions: file casing for components, routes, utilities.

### 2b. Component Architecture

Scale the hierarchy to the project:

- **MVP / small**: `ui/` (primitives), `components/` (composed), `features/` (page-level)
- **Growth-stage**: Add `patterns/` (reusable interaction patterns) and `layouts/`
- **Enterprise**: Full atomic design — atoms, molecules, organisms, templates, pages — with a separate `design-system/` package boundary

For each layer:

- What belongs there
- What it is NOT allowed to do
- How it communicates (props, context, stores, events)

### 2c. Module Boundaries

Define explicit import rules as a dependency graph:

```
pages (app/) → features → components → ui
pages (app/) → lib (server) → db/api
stores → types only
ui → types only
```

State anti-patterns explicitly (e.g. "ui components must never import from stores or lib").

---

## Phase 3 — State Orchestration

The architectural core — the map every developer will consult.

### 3a. State Classification

| Category                | Definition                                            | Tool                                         |
| ----------------------- | ----------------------------------------------------- | -------------------------------------------- |
| **Server State**        | Data owned by the server, fetched async               | React Query / SWR / tRPC / server components |
| **Global Client State** | Shared across many components, persists across routes | Zustand / Pinia / Jotai / Svelte stores      |
| **Local UI State**      | Ephemeral, one component or subtree                   | useState / useReducer / local ref            |
| **URL State**           | Encoded in URL for shareability                       | Query params / router state                  |

For each data concern the user identified, assign it to a category and justify the decision.

### 3b. Data Flow Diagram

For each major data domain, trace the full path:

```
[Data Source] → [Fetch Layer] → [State Layer] → [Component Tree] → [UI Output]
```

Include:

- Where mutations trigger re-fetches or store updates
- Which components are data owners vs. consumers
- How loading, error, and empty states propagate

### 3c. State Influence Map

For every piece of global state:

```
STATE: user.isAuthenticated
  CHANGES WHEN: login, logout, session expiry
  INFLUENCES:
    - NavBar: shows/hides user menu
    - ProtectedRoute: redirects to /login if false
  SIDE EFFECTS:
    - Clears cart state on logout
    - Triggers profile fetch on login
```

---

## Phase 4 — Design Sub-skill

Ask:

```
Architecture phase complete. Shall I proceed to the design phase?

I will produce visual implementation — component styling, layout, typography, color system, and motion — scoped to [framework] + [CSS approach].

Confirm to proceed, or specify which components or pages to design first.
```

If confirmed, invoke **faah-design** with:

- Framework and CSS approach
- Component architecture decisions
- Any design system or brand constraints from intake

---

## Research Protocol

Use **Context7** to pull current documentation for the chosen stack before making recommendations.

1. Resolve the library ID for the framework and meta-framework
2. Pull docs on: routing, data fetching, state management integration, SSR/SSG patterns
3. Base structure and pattern recommendations on current docs — not training knowledge

---

## Output Standards

- Structured markdown with clear headers
- Directory trees in standard tree notation
- State documentation in consistent tables and code blocks
- Every decision includes a one-line rationale
- Commit to specific recommendations — no "it depends" without presenting two concrete options and asking the user to choose

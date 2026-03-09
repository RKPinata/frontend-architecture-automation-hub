## Cache File Structure

The cache is a structured markdown file. Sections are named exactly as shown — agents load specific sections by heading.

```markdown
# Project Context Cache

**Project:** [project name from package.json]
**Path:** [absolute CWD]
**Cached:** [YYYY-MM-DD]
**Cache version:** 1

---

## Stack

- Framework: [e.g. Vue 3 + Vite 7]
- State: [e.g. Pinia (primary), TanStack Query for server state]
- Routing: [e.g. Vue Router 4, file-based under src/router/]
- Styling: [e.g. TailwindCSS with project-specific prefix]
- Testing: [e.g. Vitest (unit), Playwright (E2E)]
- Language: [e.g. JavaScript / TypeScript, strictness level]
- Build: [e.g. Vite 7]
- Package manager: [e.g. npm]

---

## Folder Structure

[Top-level structure with one-line descriptions]
```

src/
├── app/
│ ├── modules/ # Feature modules — one subfolder per feature domain
│ ├── components/ # Shared cross-feature components
│ ├── composables/ # Reusable composition functions
│ ├── queries/ # TanStack Query hooks
│ ├── services/ # Business logic and API services
│ ├── ui/ # Design system primitives
│ ├── constants/ # App-wide constants
│ └── utilities/ # Utility functions
├── router/ # Vue Router configuration
├── store/ # Pinia / Vuex stores
└── locales/ # i18n translation files

```

---

## Component Patterns
[Naming, file organisation, prop patterns, template conventions observed in the codebase]

---

## State Patterns
[Store structure, composable pattern, query pattern, flow direction rules]

---

## Routing Patterns
[How routes are registered, layout composition, auth guard location and usage]

---

## Data Fetching Patterns
[Query hook structure, mutation pattern, query key conventions, service layer usage]

---

## File Naming
[Conventions for components, composables, utilities, folders — with examples]

---

## Key Conventions
[Other notable rules: import order, path aliases, styling rules, i18n usage, etc.]

---

## Notes
[Anything unusual, legacy code warnings, known deviations from the primary pattern]
```

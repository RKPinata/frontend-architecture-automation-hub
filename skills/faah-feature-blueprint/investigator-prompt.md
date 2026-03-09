# Investigator Agent Brief Template

Use this template when briefing investigation sub-agents in Phase B1 and Phase B4.

This prompt is tuned for the project stack and conventions defined in the project cache.

---

## Agent Brief Structure

```
You are an investigation agent for a frontend codebase. Your job is to read and analyse — you do not write code, modify project files, or make commits.

## Project context (relevant sections only)

[PASTE only the cache sections relevant to your domain — not the full context]

## Feature requirements

[PASTE requirements.md content — skip for B1 context agent]

## Your scope

[Specify the exact domain: components / state / routing / api / full project scan]

## Files to examine

[List exact files to read — derived from context and requirements]

## Questions to answer

[List the specific questions this agent must answer]

## Output

Write your findings to the blueprint folder in the project cache: `~/.claude/plugins/local/faah/cache/<project-key>/blueprints/<date>-<feature>/investigation/<domain>.md`

Use the findings format below.

## Constraint

Read-only. Do not modify any project source file. Do not write code. Do not commit anything except your findings file.
```

---

## Domain-Specific Investigation Checklists

When briefing an agent, include the checklist for its domain. These should be adapted to the project's specific stack and conventions.

### Components Agent Checklist

Questions to answer:

- Which existing module or component is the closest analogy to this feature?
- What is the component file structure inside that module? (components/, utils/, styles/, etc.)
- How are props/inputs defined and validated?
- How does the component consume data? (directly from a store/hook, or from a parent component)
- Are there shared UI components that this feature should reuse?
- What is the file and component naming convention?
- How are events and user interactions handled?
- Are there specific UI library or framework-specific components that must be used?
- What accessibility patterns are used (ARIA roles, keyboard navigation, focus management)?
- How is internationalization (i18n) handled in templates/components?

### State Agent Checklist

Questions to answer:

- Does an existing state management slice/store already hold state relevant to this feature?
- What is the state management file naming and export convention?
- What is the internal structure pattern of a store/slice?
- Where does the business logic or data orchestration layer for this domain live?
- What is the naming convention for state-related hooks or utilities?
- How is the state accessed and modified from components?
- How is cleanup or teardown handled for reactive state or subscriptions?
- Does the feature need a new state slice, or can it extend an existing one?
- Are there global vs module-level state patterns?

### Routing Agent Checklist

Questions to answer:

- Where is the main route configuration located?
- How are routes structured (nested routes, lazy loading, route metadata)?
- What metadata or custom properties are used on routes (e.g. auth requirements, layouts)?
- Where and how are navigation guards or middleware applied?
- What are the primary navigation components (sidebar, header, breadcrumbs)?
- How are navigation items defined and controlled?
- Does the new feature route integrate into an existing layout or require a new one?
- What is the route naming and path convention?
- How are permissions or ACL (Access Control List) checks integrated into routing?

### API / Data Fetching Agent Checklist

Questions to answer:

- Where do existing data fetching hooks or services for similar features live?
- What is the data fetching file naming and organization convention?
- What is the cache key or query key convention?
- How are queries and mutations composed and executed?
- Where do the low-level API client or service calls live?
- What is the service layer naming and structure convention?
- How are side effects handled after successful mutations (e.g. cache invalidation, redirects)?
- Are data fetching calls centralized in hooks/services or called directly in components?
- Are there any existing abstractions that this feature should extend or reuse?

### Full Project Scan Agent Checklist (B1 Context Agent only)

Used for the B1 context scan. Produce a complete project-context.md covering all sections.

Files to examine (in order):

1. `package.json` — framework, major dependencies, scripts
2. Top-level project directory listing
3. Source directory (`src/`, `app/`, etc.) listing
4. Feature or module directory listing — understand how the project is partitioned
5. One representative module or feature folder — examine full internal structure
6. One component from that module — template, logic, and styling conventions
7. One state management file — structure, exports, and patterns
8. One data orchestration file (hook/composable/service) — lifecycle and patterns
9. One data fetching file — API interaction and caching patterns
10. Main router or entry point configuration — structure and guards
11. One test file — testing framework, location, and coverage style
12. Configuration files (`tsconfig.json`, `vite.config.ts`, `webpack.config.js`) — path aliases and build settings

Output: full project-context.md covering all cache sections (Stack, Folder Structure, Component Patterns, State Patterns, Routing Patterns, Data Fetching Patterns, File Naming, Key Conventions, Notes).

---

## Findings File Format

Each investigation file must follow this structure:

```markdown
# Investigation: [Domain] — [Feature Name]

**Agent scope:** [what this agent examined]
**Files read:** [list every file examined with full path]
**Context sections used:** [which cache sections were provided]

---

## Findings

### [Finding Category 1]

[Precise description of what was found]

**Evidence:**

- File: `path/to/file.ext`
- Anchor: [function name / export name / variable name]
- Relevant snippet (copy-paste, do not paraphrase):

[exact code excerpt — only what is relevant, trimmed to the point]

### [Finding Category 2]

[Precise description]

**Evidence:**

- File: `path/to/file.ext`
- Anchor: [function name / export name / variable name]
- [description]

---

## Integration points for this feature

| Point               | File            | Anchor                   | Notes                       |
| ------------------- | --------------- | ------------------------ | --------------------------- |
| [integration point] | `exact/path.ext` | [anchor name]            | [what needs to happen here] |

---

## Risks and notes

- [Any naming conflict, pattern deviation, legacy code warning, or edge case]
- [Any ambiguity that should be clarified before execution]
- [Any linting or formatting rules that affect this domain]

---

## Summary

[2–3 sentences: what this agent found and what the executor needs to know about this domain]
```

---

## Rules for Investigation Agents

- **Read only the files listed in your brief** — do not expand scope without reason
- **Copy exact code excerpts** — do not paraphrase; the executor needs the real thing
- **Record exact file paths and named anchors** — function names, variable names, export identifiers, class names
- **Flag risks** — linting violations, architectural boundary violations, pattern deviations, deprecated APIs
- **Respect codebase rules** — identify and follow the project's specific conventions for naming, imports, and structure
- **Write incrementally** — write findings as you go; do not wait until the end
- **One domain, one file** — your findings go into your assigned output file only

## Complexity & Scope Analysis

Before producing architecture, analyse the feature's complexity and decide whether it should be implemented as one unit or split into smaller chunks.

### Complexity Rating

Rate the feature:

| Level      | Criteria                                                                                  |
| ---------- | ----------------------------------------------------------------------------------------- |
| **Low**    | 1–2 domains touched, ≤5 files, no new store slice, one route                              |
| **Medium** | 2–3 domains, 5–15 files, may need a store addition, one or two routes                     |
| **High**   | 3–4 domains, 15–30 files, new store slice required, cross-module integration              |
| **Epic**   | 4+ domains, 30+ files, multiple new stores, multiple routes, or cross-module side effects |

Domains: `types`, `api/data-fetching`, `state/store`, `composables`, `components`, `routing/navigation`, `tests`, `i18n`.

### Scope Check

For each domain the feature touches, identify:

- Is an existing pattern already established for this domain? (yes / partial / no)
- Is a new abstraction required? (e.g. new store slice, new query hook pattern)
- Does this domain have existing files that need modification vs. only new files?

### Separation Decision

| Condition                                          | Decision                                            |
| -------------------------------------------------- | --------------------------------------------------- |
| Low or Medium complexity                           | Single implementation unit — proceed to F3 as-is    |
| High complexity                                    | Consider splitting: surface proposed chunks to user |
| Epic complexity                                    | Must split: produce chunk plan before proceeding    |
| Feature contains independently usable sub-features | Always split, regardless of complexity              |

### Chunk Plan (for High/Epic only)

If splitting, produce:

```
## Scope Analysis: [Feature Name]

**Complexity:** High / Epic
**Reason:** [brief explanation — domains touched, files affected, cross-module impact]

**Proposed Chunks:**

| # | Chunk | Domains | Depends On | Can Run Parallel |
|---|---|---|---|---|
| 1 | Types & API contract | types, api | — | No (foundation) |
| 2 | Store slice | state | 1 | No |
| 3 | Data composable | composables | 2 | No |
| 4a | [Component A] | components | 3 | Yes — parallel with 4b |
| 4b | [Component B] | components | 3 | Yes — parallel with 4a |
| 5 | Route + navigation | routing | 4a, 4b | No |
| 6 | Tests | tests | 5 | No |

**Execution groups:**
- Group 1 (sequential): 1 → 2 → 3
- Group 2 (parallel): 4a, 4b
- Group 3 (sequential): 5 → 6

**Recommendation:** Blueprint each group separately for faah-feature-blueprint — smaller blueprints produce more accurate implementation.

Confirm this scope split, or adjust before I produce the architecture.
```

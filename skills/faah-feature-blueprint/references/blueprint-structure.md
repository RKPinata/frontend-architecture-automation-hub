## Output Structure

Every blueprint run produces a folder **inside the project cache** (not in the git repo):

```
~/.claude/plugins/local/faah/cache/<project-key>/blueprints/YYYY-MM-DD-<feature-name>/
├── README.md                     — orientation: what this blueprint is, how to use it
├── context.md                    — project pattern summary (stack, conventions, folder rules)
├── requirements.md               — confirmed feature requirements, user story, scope
├── scope.md                      — complexity rating, chunks, execution groups (if feature was split)
├── investigation/
│   ├── components.md             — component layer findings
│   ├── state.md                  — state management findings
│   ├── routing.md                — routing and navigation findings
│   └── api.md                    — API / data fetching findings
├── affected-files.md             — every file:line that needs to change, with rationale
├── implementation-sequence.md    — ordered task list for an executor agent
└── .progress                     — internal progress tracker (do not delete)
```

**Project key** is computed from CWD (see `faah-project-cache`). Example:
`/path/to/my-project` → `path-to-my-project`

Create the folder and all files during execution. Each file is written as its phase completes — not all at the end.

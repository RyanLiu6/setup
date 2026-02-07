---
name: clean-docs
description: Evaluate and clean stale docs from ~/dev/docs/ using haiku sub-agents
---

# Clean Docs

Scan `~/dev/docs/` for stale documentation and present a cleanup plan for user approval.

@../../memory/project-notes-workflow.md

## Classification Rules

Each doc falls into one of three categories:

| Category | Action | Examples |
|----------|--------|---------|
| **RFD / Discussion** | KEEP (always) | Design proposals, architecture decisions, trade-off analyses |
| **Investigation Notes** | KEEP (always) | Debugging notes, "how does X work?", research findings |
| **Implementation Plan / Tracker** | CHECK | Step-by-step plans, task checklists, migration trackers |

**Never delete** RFDs or discussion documents, regardless of age.

## Process

### 1. Discover docs

```bash
ls ~/dev/docs/
```

List all subdirectories under `~/dev/docs/`. Each subdirectory represents a repo.

### 2. Spin up haiku sub-agents per repo

For each repo subdirectory, launch a **haiku sub-agent** using:

```
Task tool with:
  model: haiku
  subagent_type: Bash
```

Each agent should:

1. List all `.md` files in `~/dev/docs/<repo-name>/`
2. Read each file
3. Classify it as one of: `RFD/Discussion`, `Investigation`, or `Implementation Plan`
4. For files classified as `Implementation Plan`:
   - Find the corresponding repo under `~/dev/` (search for a directory matching `<repo-name>` that contains a `.git` directory)
   - Check if the planned work appears to be completed (look for relevant commits, merged branches, or code matching the plan)
   - Mark as `STALE` if work is done, `ACTIVE` if still in progress or repo not found
5. Return a structured summary: one line per file with `filename | category | recommendation (KEEP/STALE)` and a brief reason

Launch agents **in parallel** — one per repo directory.

### 3. Collect results and present summary

Aggregate all agent results into a single table:

```
| Repo | File | Category | Status | Reason |
|------|------|----------|--------|--------|
| my-repo | architecture.md | RFD | KEEP | Design document |
| my-repo | migration-plan.md | Implementation Plan | STALE | All migrations completed in abc123 |
```

### 4. Confirm with user before any deletion

- Present the full table
- Highlight which files are recommended for deletion (STALE only)
- **Ask the user for explicit confirmation** before deleting anything
- Only delete files the user approves

## Key Principles

- **Conservative by default**: When uncertain, recommend KEEP
- **Never delete RFDs or investigation notes**: These have long-term value
- **User always decides**: This skill only recommends — the user confirms
- **Parallel execution**: Use haiku sub-agents to process repos concurrently

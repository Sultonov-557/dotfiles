---
name: project-archivist
description: Review a project deeply (architecture, flows, business logic) and persist a structured, versioned knowledge record to memory so future sessions can recall it without re-reading the codebase. Use when the user asks to "remember this project", "archive this codebase", "remember the architecture of X", or wants a project reviewed and stored in memory. Idempotent: re-runs detect changes since the last archive and update incrementally.
---

# Project Archivist

Capture a project's architecture, key flows, and business rules into memory as a versioned, drift-aware knowledge record. Re-runs update incrementally instead of overwriting.

## When to Use

Use this skill when the user asks to:
- "remember this project" / "archive this codebase" / "save this project to memory"
- "review the project and remember it"
- "what's the architecture of X?" when X has not yet been archived
- Re-archive a project that has changed since the last archive
- Capture business logic, flows, or rules of a known project for later retrieval

Do not use for: single-file code reviews, debugging a specific bug, or one-off questions. This skill's purpose is **persistent project-level knowledge capture**.

## Inputs

The skill accepts these arguments (from the user or defaults):

| Argument | Default | Purpose |
|---|---|---|
| `project_path` | cwd | Absolute path to the project root |
| `memory_scope` | `project` | `project` or `all-projects` |
| `depth` | `standard` | `quick` (stack+structure only) / `standard` (default) / `deep` (incl. function signatures) |

If the user does not provide `project_path`, ask for it before proceeding. Do not silently default to cwd unless the user clearly meant the current directory.

## Output: Memory Schema

Each archive produces a small set of memory entries. All entries are tagged with the project name (slugified) and carry this metadata in their content body:

```
project:        <name>
arch_version:   <N>
architected_at: <ISO8601>
architected_by: project-archivist
source_path:    <absolute project path>
```

### Entry types (always written on a fresh archive)

1. **`<project>: stack-and-structure`** — tech stack, languages, runtime versions, top-level directory map, entry points
2. **`<project>: key-flows`** — one or more entries, one per major flow (entry → path → side effects → output)
3. **`<project>: business-rules`** — validation logic, state machines, auth rules, business constraints
4. **`<project>: dependencies`** — runtime, dev, key external integrations

A project may produce multiple flow entries (one per flow) but typically one each of the others.

### Tags

Every entry gets:
- `project-<slug>` (e.g. `project-opencode-mem`)
- `architecture` (always)
- One of: `stack`, `flows`, `business-rules`, `dependencies`
- One of: `archive-v1`, `archive-v2`, ... (the version)

## Procedure

### Stage 1: Detect Prior Archive

Before doing anything, search memory for the project.

```
memory(mode="search", query="<project-name>", scope="<memory_scope>")
```

Examine results for entries tagged with `project-<slug>`. If found, extract:
- `arch_version` (the current version, e.g. `3`)
- `architected_at` (the timestamp of the most recent archive)
- `source_path` (verify it matches the input path)
- `source_files_ref` (the list of files reviewed last time, if present)

**If no prior archive exists → proceed to Stage 3 (Fresh Archive).**
**If a prior archive exists → proceed to Stage 2 (Diff & Update).**

### Stage 2: Diff & Update (Re-run Path)

#### 2a. Detect Changes (tiered)

Try in order; use the first that works.

**Tier 1 — Git (preferred):**
```
git -C <project_path> log --since="<architected_at>" --name-only --pretty=format:"%H %s"
```
This returns commits with changed files. Parse to get:
- Changed file list
- Commit messages (useful for changelog)

If the project is not a git repo, or git fails, fall through.

**Tier 2 — File mtime:**
```
find <project_path> -type f -newer <last_archive_timestamp_marker> -not -path "*/node_modules/*" -not -path "*/.git/*"
```
Requires a sentinel file or mtime reference from the prior archive. If not available, fall through.

**Tier 3 — Full re-scan fallback:**
Warn the user that no diff is possible. Ask if they want a full re-archive or to skip. Do not silently do a full re-archive.

#### 2b. Classify Drift

Count changed files vs. total reviewed files from `source_files_ref`.

- **No changes** → output: "Project unchanged since archive v<N>. No update needed." and stop.
- **Minor changes** (≤ 25% of files) → proceed with incremental update
- **Moderate changes** (26–50%) → proceed with incremental update, flag in changelog
- **Major changes** (> 50%) → STOP. Show the user the diff summary and ask:
  - "Drift is large. Append new state, full re-archive (supersedes v<N>), or skip?"

#### 2c. Incremental Update (Minor/Moderate Drift)

For each changed file:
1. Read it, identify which entry types it affects (flows / rules / structure / deps)
2. For each affected entry: decide between UPDATE (patch in place) or APPEND (new sub-entry)
3. **Never silently delete content.** If a flow is removed, write a deprecation note tagged `superseded` and reference the new version.

Write a **changelog memory entry**:
```
title:    <project>: changelog v<N> → v<N+1>
content:  <date range, changed files, semantic summary of what changed>
tags:     [project-<slug>, changelog, archive-v<N+1>]
```

Bump `arch_version` to `N+1` on all updated entries. Re-write them with new metadata.

#### 2d. Report

Output:
- "Updated v<N> → v<N+1>"
- List of files changed
- List of memory entries touched (with their IDs)
- Confirmation that a changelog entry was written

### Stage 3: Fresh Archive

#### 3a. Discover Structure

```
- list top-level directories (depth 1, excluding node_modules, .git, dist, build, target)
- find package.json, Cargo.toml, go.mod, pyproject.toml, requirements.txt, Gemfile, etc.
- find README*, docs/, ARCHITECTURE*, CONTRIBUTING*
- find src/, lib/, app/, cmd/, internal/ entry points
```

#### 3b. Detect Stack

From the manifest files, extract:
- Language(s) and version
- Framework(s)
- Runtime
- Test framework
- Build tool

#### 3c. Map Structure

For each top-level module/folder, write a one-line purpose. Skip generated/vendor directories.

#### 3d. Extract Flows

Identify the 2–5 most important flows. A flow is a sequence: **input → processing → side effects → output**. Examples:
- Auth flow (login → validate → issue token → response)
- Request flow (incoming request → routing → handler → DB → response)
- Build flow (source → compile → artifacts → publish)

For each flow, capture: trigger, steps with file:line refs, side effects (DB writes, network, FS), outputs.

If `depth=deep`, also capture the function signatures of the key handlers.

#### 3e. Extract Business Rules

Look for:
- Validation functions (input checks, schema validators)
- State machines (enum states + allowed transitions)
- Authorization rules (who can do what)
- Domain constraints (e.g. "users can have max 5 projects")
- Money/time/quantity limits
- Error handling that encodes business intent

Cite each rule with file:line ref.

#### 3f. Surface Dependencies

- **Runtime dependencies** — what the project needs at runtime
- **Dev dependencies** — test/lint/build tools
- **External integrations** — third-party APIs, services, databases
- Note any that look unusual or load-bearing.

#### 3g. Persist to Memory

For each entry type, call:

```
memory(
  mode="add",
  content=<entry body with metadata header>,
  tags=[project-<slug>, architecture, <type>, archive-v1],
  scope=<memory_scope>
)
```

Capture each returned `id` for the report.

#### 3h. Report

Output a summary:
```
Archived <project> as v1
  - 1 stack-and-structure entry  → id_xxx
  - N flow entries               → id_yyy, id_zzz
  - 1 business-rules entry       → id_aaa
  - 1 dependencies entry         → id_bbb
Next run will diff against this baseline.
```

## Quality Rules

- **Cite everything.** Every flow step, every business rule, every dep should have a file:line ref or explicit "from package.json" attribution. No hand-waving.
- **Skip the noise.** Generated code, lock files, vendored deps, minified assets — do not archive these.
- **Prefer durable signal.** Capture intent and rules, not variable names. Future-you wants to know "auth uses JWT with 15-min expiry" not "the function is called `makeToken`".
- **Never silently delete.** Use `superseded` tags and changelog entries. The audit trail is the point.
- **One project = one slug.** Pick `<project-name>` (folder name, lowercased, dashed) and use it consistently across all entries for that project.
- **Version bumps are atomic.** Either all entries for a project move to v<N+1>, or none do. Never half-update.

## Edge Cases

- **No git, no mtime available, fresh archive** → fine, just skip the diff metadata
- **Project path moved** → fuzzy-match by `source_path` prefix; if matched, ask user to confirm migration to new path
- **Memory tool error** → report failure, do not write partial state. If some entries were written, list them and warn the user that they are orphaned v<N+1> entries needing manual cleanup
- **Project is huge (>10k files)** → sample key directories, note in entry that archive is partial; suggest `quick` depth first
- **Re-run from a different machine** → metadata includes machine-agnostic `source_path`; git-based diff still works if remote is accessible

## Anti-Patterns

- Do **not** write entries that just duplicate file contents. Memory is for **knowledge**, not source.
- Do **not** capture secrets, credentials, or `.env` content. Ever.
- Do **not** archive generated docs (`/docs/build/`, `node_modules/`, `dist/`).
- Do **not** bump version on cosmetic-only diffs (whitespace, reformat). Wait until a re-run with actual semantic change.
- Do **not** invoke this skill speculatively. Only on explicit user request.

## Verification

After writing entries, the skill should:
1. List the created entry IDs
2. Run a `memory(mode="search")` to confirm they are retrievable
3. Show the user a one-screen summary of what was archived

If any entry is not retrievable, warn the user — silent write failures defeat the purpose.

---
name: explain-my-pr
description: Use when preparing a merge request or git MR and the reviewer (lead/manager) needs a plain-language explanation of code changes. Triggers include MR submission, merge review docs, or "explain this diff for my reviewer."
---

# Writing Git MR Change Explanation Docs

Produce a **manager-friendly MR explanation document** in the same style as [examples/example-output.md](examples/example-output.md). The reader has **not** seen the code; they need *why*, *what broke before*, and *what is safe after*.

## Before Writing

1. **Gather git facts** (run in the MR branch):
   - `git diff <base-branch>...HEAD --stat`
   - `git diff <base-branch>...HEAD -- <paths>`
   - `git log <base-branch>..HEAD --oneline`
2. **Scope one doc per logical unit** — usually one primary file or one cohesive feature (not the whole repo).
3. **Name branches explicitly** in before/after labels (e.g. `main (before)`, `feat/my-branch (after)`).

## Sensitive or employer-specific content

- **Never commit** real MR docs that describe proprietary code, internal repos, or customer data. User keeps those in gitignored files (see `examples/.gitignore`).
- **Branch names:** For docs that may be shared publicly or committed to an open repo, use neutral names (`main`, `develop`, `feat/short-description`). Map employer-specific prefixes (e.g. internal `dt-*` branches) to `main` / `feat/...` in the written doc unless the user says the doc stays internal-only.
- **Repos and paths:** Fictionalize or generalize package names in public examples (`acme_agent/...`); use real paths only when the user confirms the output stays private.

## Output Location

Unless the user specifies another path, save under:

`docs/mr-change-explanations/<short-topic>.md`

Use kebab-case filenames (`base-tool-changes.md`, `auth-middleware.md`). Create the directory if missing.

## Required Document Shape

Follow sections **in this order** (see [reference.md](reference.md) for fill-in template):

| # | Section | Purpose |
|---|---------|---------|
| 1 | Title + intro | `# Why … changes when merging X into Y` — files touched, line count, audience |
| 2 | What is X and why does it matter? | 3–6 bullets: role of the code in the system |
| 3 | TL;DR table | One row per distinct fix/change: #, What changed, Why it matters |
| 4 | Big picture | ASCII diagram of call flow / architecture |
| 5 | Fix 1…N (repeat) | Per change: problem → code before/after → step-by-step → safety → status today |
| 6 | All fixes together | Numbered trace: broken path (base) vs working path (MR) |
| 7 | Impact table | What changes for existing consumers (usually "nothing" + opt-in rows) |
| 8 | Reviewer checklist | 3–5 concrete things to grep/verify before merge |
| 9 | Suggested commit message | Multi-line conventional commit block |
| 10 | Reference table | File paths + line ranges on both branches |

Separate major sections with `---`.

## Writing Rules (Non-Negotiable)

- **Simplest possible language** — no jargon without a one-sentence definition.
- **Concrete examples** — real field names, errors, log lines.
- **Code citations** use `path/to/file.py:start-end (branch-name):` then a fenced block; annotate *inside* the block with `# ↑` or comments explaining the delta.
- **Before/after always paired** — never show only the new code.
- **Additive/safe by default** — end each fix with why existing callers are unchanged unless they opt in.
- **Status today** — what is enabled in config *right now* vs what the fix unlocks later.
- **Honest scope** — if the MR is 35 lines, say 35 lines; don't pad.

## Per-Fix Section Pattern

```markdown
## Fix N — Short title (plain English)

### What problem this fixes
[Symptom in production/logs/tests. Concrete case.]

### The change in code

#### <base-branch> (before)
`path/file.py:76-94` (<base-branch> branch):
```python
# ... snippet with comments ...
```

#### <mr-branch> (after)
`path/file.py:76-99` (<mr-branch> branch):
```python
# ... snippet ...
```

### Step-by-step: how the new path works
1. ...
```

Add `### Why this is a safe change` and `### Status today` when relevant.

## Quality Checklist (Before Handing to Reviewer)

- [ ] Title states merge direction (`merging A into B`)
- [ ] TL;DR row count matches number of `## Fix` sections
- [ ] Every code block has branch label and line range
- [ ] At least one end-to-end numbered trace (broken vs fixed)
- [ ] Impact table covers "nothing changes" cases explicitly
- [ ] Reviewer checklist has actionable grep/search items
- [ ] Companion doc links if sibling docs exist in the same output folder

## Anti-Patterns

| Don't | Do instead |
|-------|------------|
| Bullet dump of file names | One narrative per fix with why |
| "Refactored for clarity" | Name the bug or limitation removed |
| Diff-only paste without labels | Label `before` / `after` with branch names |
| Assume reviewer knows framework jargon | One-sentence definition on first use |
| One giant section for unrelated files | Split into separate `.md` files |

## Canonical Example

When unsure about tone or depth, read [examples/example-output.md](examples/example-output.md). Match its level of detail, tables, ASCII diagrams, and reviewer checklist. For internal-only work, the user may also keep a longer private example locally (gitignored).

## Full Template

Copy structure from [reference.md](reference.md).

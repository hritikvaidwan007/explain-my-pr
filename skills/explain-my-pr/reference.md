# MR Change Doc — Full Template

Copy this skeleton and replace placeholders. Delete sections that do not apply (e.g. skip "All fixes together" if there is only one trivial change).

---

```markdown
# Why `<component>` changes when merging `<source-branch>` into `<target-branch>`

This doc explains the changes to <scope — one file, one module, or one feature>:

> `<repo-relative/path/to/file.py>` — <one sentence: what this file/class does in the system>.

The merge changes <N> lines in this <file/feature>. <M> separate <fixes/changes>, all in <location e.g. one method>. This doc walks through each one with code examples and exact line numbers, written for a reader who has not seen this code before.

---

## What is `<Symbol>` and why does it matter?

<Every X inherits from / calls / depends on …>. When the LLM / user / service does Y, this code is the **single entry point** that:

1. ...
2. ...
3. ...

So if `<method>` has a bug or a blind spot, **<who inherits the bug>**. That's why a <N>-line change here matters more than it looks.

---

## TL;DR — <N> fixes, <one unit>

| # | What changed | Why it matters |
|---|---|---|
| 1 | <one line, active voice> | <user-visible or ops impact> |
| 2 | ... | ... |

All fixes are **added on top of existing code**. <Consumers> that don't opt in keep working exactly as before.

---

## Big picture — where `<method>` sits

```
<ASCII flow: caller → layer changed → callee → output>
```

`<method>` is the layer between <A> and <B>. The fixes change *what* this layer is allowed to <see / do / log>.

---

## Fix 1 — <Short title>

### What problem this fixes

<Symptom>. **Concrete case:** <real field, error string, or log line>.

<Optional: table comparing failure modes>

### What's a `<Term>`?  <!-- only if jargon needed -->

<One paragraph plain English + optional small example dict/code>

### The change in code

#### <base-branch> (before)

`<path>:<start>-<end>` (<base-branch> branch):

```python
# ... before snippet ...
# ↑ Comment pointing at the limitation
```

#### <mr-branch> (after)

`<path>:<start>-<end>` (<mr-branch> branch):

```python
# ... after snippet ...
```

### Step-by-step: how the new path works

1. **<Actor> does X** — <where in codebase, link if helpful>
2. ...
3. ...

### Why this is a safe change for existing <consumers>

<Opt-in mechanism, feature flag, signature check, etc.>

### Status today

<What is deployed/enabled now vs follow-up work.>

---

## Fix 2 — ...

(repeat Fix 1 structure)

---

## All <N> fixes together — one example trace

Imagine a single <user turn / request / job> that uses all fixes.

### What happens on <base-branch> (broken in <N> places)

```
1. ...
2. ...
```

<List what went wrong mapped to missing Fix 1, 2, …>

### What happens on <mr-branch> (all working)

```
1. ...
...
```

---

## What this means for <tools/callers/services> that already exist

| Type of <consumer> | What changes? |
|---|---|
| <common case> | Nothing. <why> |
| <opt-in case> | Can now <new capability>. |

So: **no existing <consumer> breaks. Some can now do more if they want to.**

---

## Reviewer checklist when merging

<N> things worth double-checking:

1. **<Question?>** <Answer or how to verify — grep path, test, dependency>
2. ...
3. ...

---

## Suggested commit message for the merge

```
<type>(<scope>): <subject line ≤ 72 chars>

<Body paragraph explaining the MR for git log readers>

  1. <fix one>
  2. <fix two>
  3. ...

<Backward-compat note>. +<adds> / -<deletes> in <path>.
```

---

## Reference — exact line ranges

| What | File | Lines (<mr-branch>) | Lines (<base-branch>) |
|---|---|---|---|
| `<method>` | `<path>` | `76–122` | `76–103` |
| ... | ... | ... | ... |

### Companion docs in this folder

- [`<other-doc>.md`](<other-doc>.md) — <one line what it covers>
```

---

## Style Notes from `examples/example-output.md`

Public sample uses neutral branches (`main`, `feat/forward-request-context`) and fictional package `acme_agent`. Internal docs may use real branches; gitignore those files before push.

- **Opening hook** ties the doc to a specific merge (`feat/X into main`), not a generic "changes in this PR".
- **TL;DR table** is the only place a busy lead needs if they stop early.
- **Fix sections** always answer: what broke, what we changed, why safe, what's live today.
- **Side-by-side log output** when behavior is observable in logs.
- **Numbered traces** (10+ steps) show causality — especially for interrupt/async/framework bugs.
- **Reviewer checklist** names real grep strings and edge cases (`*args/**kwargs`, missing dependency).
- **Commit message** mirrors TL;DR numbered list and includes `+/-` line stats.
- Use `>` blockquote for the primary file path in the intro.
- Emoji in log examples only when matching real logger output (`🔧`, `✅`, `⚠️`, `❌`).

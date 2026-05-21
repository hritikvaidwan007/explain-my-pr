# Why `BaseTool.execute()` changes when merging `feat/forward-request-context` into `main`

This doc explains changes to one file in a **fictional** framework package (`acme-agent-framework`):

> `acme_agent/tools/base.py` — defines `BaseTool`, the base class every agent tool inherits.

The merge changes 28 lines in this file. Two separate fixes in the same method (`BaseTool.execute()`). Written for a reviewer who has not seen this code.

---

## What is `BaseTool.execute()` and why does it matter?

When the LLM calls a tool (e.g. `update_record`), the framework runs `BaseTool.execute()`. That method:

1. Validates input against `input_schema`
2. Calls the subclass `_execute()`
3. Logs the outcome
4. Catches exceptions and returns `ToolOutput`

A bug in `execute()` affects **every tool** in the framework.

---

## TL;DR — two fixes, one method

| # | What changed | Why it matters |
|---|---|---|
| 1 | `execute()` can pass request `RunContext` to `_execute()` when the subclass opts in | Per-request values (e.g. `actor_id`) need not be LLM tool arguments |
| 2 | Success logs only when `result.ok` is true; failures log `⚠️` | Log grep matches reality |

Both fixes are **additive**. Tools that do not opt in behave as before.

---

## Big picture

```
LLM → tool wrapper → BaseTool.execute() → _execute() → ToolOutput
```

---

## Fix 1 — Pass `RunContext` to `_execute()` (opt-in)

### What problem this fixes

The agent already knows `actor_id` for the HTTP request. Putting it in `input_schema` forces the LLM to copy it on every call — often wrong or empty.

### The change in code

#### main (before)

`acme_agent/tools/base.py:70-82` (main branch):

```python
async def execute(self, **kwargs) -> ToolOutput:
    validated = self.input_schema(**kwargs)
    result = await self._execute(**validated.dict())
    # ↑ RunContext never reaches _execute
```

#### feat/forward-request-context (after)

`acme_agent/tools/base.py:70-88` (feat branch):

```python
async def execute(self, _run_context=None, **kwargs) -> ToolOutput:
    validated = self.input_schema(**kwargs)
    sig = inspect.signature(self._execute)
    if "context" in sig.parameters:
        result = await self._execute(**validated.dict(), context=_run_context)
    else:
        result = await self._execute(**validated.dict())
```

Wrapper at `acme_agent/tools/base.py:102-104`:

```python
async def wrapper(context: RunContext = None, **kwargs):
    return await self.execute(_run_context=context, **kwargs)
```

### Why this is safe

Only subclasses that declare `context` on `_execute()` receive it.

### Status today

Framework supports opt-in; most app tools still pass `actor_id` via schema — migration is optional follow-up.

---

## Fix 2 — Honest logging for structured failures

### What problem this fixes

Tools can return `ToolOutput(ok=False)` without raising. On `main`, `execute()` always logged success.

### The change in code

#### main (before)

```python
result = await self._execute(...)
logger.info("✅ Tool %s completed", self.name)
```

#### feat/forward-request-context (after)

```python
result = await self._execute(...)
if result.ok:
    logger.info("✅ Tool %s completed", self.name)
else:
    logger.warning("⚠️ Tool %s failed: %s", self.name, result.error)
```

---

## All fixes together — one trace

**On `main`:** LLM passes `actor_id` in kwargs; wrong value stored; logs show ✅ even when `ok=False`.

**On `feat/forward-request-context`:** `actor_id` read from `context`; logs show ⚠️ when `ok=False`.

---

## What this means for existing tools

| Tool type | What changes? |
|-----------|----------------|
| No `context` param on `_execute()` | Nothing |
| Always `ok=True` | Log line unchanged |
| Wants request-scoped settings | Add `context=None` to `_execute()` |
| Uses `ok=False` | Warning log instead of false ✅ |

---

## Reviewer checklist

1. Search for `_execute(self, *args, **kwargs)` — `inspect.signature` may not see `context` on variadic tools.
2. Confirm monitoring does not count `"completed"` as success for all tool runs.
3. Run one integration test with and without `context` on a sample tool.

---

## Suggested commit message

```
feat(tools): opt-in RunContext forwarding + honest tool result logs

- Forward RunContext to _execute when subclass declares `context`
- Log warning when ToolOutput.ok is false

Additive; existing tools unchanged. +28 / -11 in acme_agent/tools/base.py
```

---

## Reference — line ranges (fictional)

| What | File | feat branch | main |
|------|------|-------------|------|
| `execute()` | `acme_agent/tools/base.py` | 70–95 | 70–82 |
| Context dispatch | same | 84–88 | n/a |
| Result logging | same | 90–94 | 81 |

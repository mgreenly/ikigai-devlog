---
title: "Standardized Output for AI Agents"
slug: "standardized-output"
published: 2026-01-19
republished: []
last_build_hash: ""
last_build_lines: 0
---

When you hand off a task to another person, you reduce their cognitive load by giving them clear, consistent information. The same principle applies to AI agents.

In the ikigai project, every quality check—compilation, tests, coverage, file size, memory sanitizers—follows the same output contract:

```json
{"ok": true}
```

Or on failure:

```json
{"ok": false, "items": ["src/array.c:42: undefined reference to 'foo'", "..."]}
```

That's it. The agent doesn't need to parse different output formats for `make check-unit` versus `make check-coverage`. It doesn't need to understand GCC error formats versus Valgrind reports versus test framework output. The harness scripts handle all that translation.

## Why This Matters

The benefits compound quickly:

**Parallel execution becomes trivial.** Run all checks simultaneously and let the scripts sort out the interleaved output. The agent receives clean JSON, not garbled terminal noise.

**Error messages stay flexible.** The items array can contain simple strings like `"file.c:10: error"` or structured objects with `file`, `line`, and `desc` fields. Agents figure this out without explicit documentation—they're good at inferring structure from examples.

**Prompts get simpler.** Instead of explaining each tool's quirks, the agent just knows: run the check, parse the JSON, fix what's in the items array.

## The Pattern

Each check script lives in `.claude/scripts/` and wraps the underlying build system:

```
check-build    → make all
check-unit     → make check-unit
check-coverage → make check-coverage
check-filesize → make check-filesize
```

The scripts parse tool-specific output and emit uniform JSON. It's a small investment that pays off every time an agent interacts with your build system.

*Co-authored by Mike Greenly and Claude Code*

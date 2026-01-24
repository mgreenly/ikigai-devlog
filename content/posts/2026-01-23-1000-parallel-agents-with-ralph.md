---
title: "Parallel Agents with Ralph"
slug: "parallel-agents-with-ralph"
published: 2026-01-23
republished: []
last_build_hash: ""
last_build_lines: 0
---

My typical workflow now involves 2-3 agents running in parallel terminals. One finishes, I feed it a new goal, and it's off again. PRs get auto-merged. The cycle repeats.

This wouldn't work without three pieces: the ralph loop, the quality harness, and jujutsu.

## The Ralph Loop

Ralph is a [script](https://github.com/mgreenly/ikigai/tree/main/.claude/harness/ralph) that runs `claude -p` in a loop until a goal is achieved.

The key is the prompt template. Ralph wraps every goal in the same structure: the goal itself, accumulated progress from prior iterations, available skills, and harness scripts for validation. This takes all the boilerplate out of goal creation. You just write what you want done. The template handles everything else: what tests to run, how to validate, how to create the PR, how to report progress.

Each iteration, the agent works toward the goal and returns a progress message. Ralph logs that and includes it in the next iteration's prompt.

But raw progress logs would exhaust context after a few iterations. So starting at iteration 10, ralph summarizes older progress while keeping recent iterations verbatim. The agent maintains full awareness of its history without running out of context. I've seen ralph run for 30 hours and successfully deliver on complex goals.

It just keeps working until it returns "DONE".

## The Quality Harness

Ralph wouldn't work well without the harness scripts. These are wrappers around make targets that return terse JSON:

```json
{"ok": true}
{"ok": false, "items": ["src/foo.c:10: error msg"]}
```

The agent runs these to validate its work: compile, unit tests, integration tests, sanitizers, coverage. No output parsing required. The JSON tells it exactly what failed and where.

This gives the loop teeth. Without clear validation, the agent would thrash. With it, the agent knows immediately whether its change worked.

## Jujutsu Enables the Workflow

The third piece is [jj (jujutsu)](https://docs.jj-vcs.dev/latest/), which makes parallel agents practical.

The workflow in each terminal:

1. `jj git fetch` to pull recently merged work
2. `jj new main@origin` to start a fresh working copy
3. Have an interactive session to build the goal file
4. `ralph --goal=the-goal.md`

Ralph rebases on `main@origin` before pushing, so there's a good chance of no conflicts. We also try not to run goals that touch the same code at the same time.

When conflicts do happen, it's simple: `jj git fetch && jj rebase -d main@origin`, then `ralph --continue`. Ralph picks up where it left off and fixes the conflicts.

## The Result

We're not supervising agents anymore. We're feeding them goals and PRs auto-merge. The agents do the implementation. The harness catches their mistakes. The version control handles concurrency. The human element comes back at release time, when we re-run all the validation manually before cutting a release.

This is what agentic development looks like when the infrastructure is solid enough to trust.

*Co-authored by Mike Greenly and Claude Code*

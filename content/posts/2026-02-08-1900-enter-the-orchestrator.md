---
title: "Enter the Orchestrator"
slug: "enter-the-orchestrator"
published: 2026-02-08
republished: []
last_build_hash: ""
last_build_lines: 0
---

The ralph harness has been running effectively for weeks now. It tracks progress, summarizes history, and can grind through complex goals for 30 hours when needed (though most finish in a single iteration). We have a solid foundation for autonomous development.

But I was becoming the bottleneck.

## The Human Orchestrator Problem

Every time an agent needed a new task, I was there: resetting the repo to main@origin, writing the goal file, starting ralph, spot-checking results, deciding whether to merge or iterate. Rinse and repeat across 2-5 parallel agents.

This manual orchestration worked, but it was constant low-grade overhead. I couldn't step away for long. Each agent finishing meant another round of setup work. The mechanical parts were eating into time I could spend on actual problem-solving.

So we built an orchestrator.

## Resource Management, Not Task Planning

The orchestrator's job is deliberately narrow: if there are available compute resources and queued goals, spawn ralphs to complete them. That's it.

Ikigai is a C project with heavy static and dynamic analysis. Valgrind, sanitizers, coverage builds. Two or three ralphs running concurrently is enough to peg all 48 CPU cores on my machine. Resource management isn't abstract here.

The orchestrator helps by stretching work over time. I can queue up a dozen goals before bed and the orchestrator will chew through them overnight, using the limited compute when I don't need to be present. The bottleneck becomes how fast I can write good goals, not how many hours I can sit at the keyboard.

We're using GitHub Issues as the goal database. Goals get labeled with their current state: `goal:draft`, `goal:queued`, `goal:running`, `goal:done`, `goal:stuck`. The orchestrator watches for queued goals and picks them up.

When it spawns a ralph, the orchestrator:

1. Clones the repo to an isolated directory under `.ralphs/`
2. Writes the goal body to a gitignored file in the clone
3. Launches ralph with the appropriate model and reasoning settings
4. Streams ralph's output to a log file (so `watch-ralphs` can aggregate and display all running ralphs)
5. Watches for completion

On success, the orchestrator creates a PR, enables automerge, and marks the goal done. On failure, it re-queues the goal for retry (up to 3 attempts). If something needs human review, it transitions to `goal:spot-check` and sends a notification.

```
orchestrator --max 5 --model sonnet --reasoning med --duration 4h
```

This runs up to 5 concurrent ralphs, each with a 4-hour time budget. The orchestrator handles all the lifecycle management that was eating my time.

## Stories and Goals

Goals are GitHub Issues with a specific structure. Creating one links it to a parent "story" (also an issue) for loose organization:

```
goal-create --story 42 --title "Add widget rendering" <<'EOF'
## Objective
Implement the widget rendering pipeline.

## Acceptance
- Widgets render correctly in the terminal
- All existing tests pass
EOF
```

The orchestrator processes queued goals FIFO. There's basic support for declaring dependencies between goals, but we haven't needed sophisticated planning yet. Queue them in order and let the orchestrator chew through them.

## What This Frees Up

The orchestrator handles the mechanical loop. I can now focus on:

- Writing goals and stories (the creative work)
- Reviewing spot-check requests when they arrive
- Analyzing failed goals to understand what went wrong
- Curating the goal queue

I'm no longer stuck in a tight feedback loop of reset-start-check-merge. The infrastructure runs that loop for me.

## Measuring What Matters

How do I know if the orchestrator is actually making things faster? We've started tracking stats.

Every ralph run logs its metrics to `~/.local/state/ralph/stats.jsonl`: iterations completed, tokens consumed, cost, time breakdowns (LLM time, tool time, overhead), and lines of code changed. A separate dashboard project reads this file and visualizes the data.

This gives me concrete answers to questions like: How much does a typical goal cost? How long does it take? What's the ratio of LLM thinking time to tool execution? Are certain types of goals consistently failing?

With the orchestrator running autonomously, I can analyze throughput over time. If I'm completing more goals per day with less hands-on time, the investment in automation is paying off. If not, I'll know where to look for bottlenecks.

## Looking Ahead

Right now the orchestrator lives inside the Ikigai repository. You run it from that directory and it manages work for that repo.

The next step is divorce: extracting the orchestrator into its own standalone repository. Once that's done, it can watch multiple repos, picking up queued goals from any project I maintain. One orchestrator, many projects.

The goal is to reach a point where I'm curating a backlog across all my work, and the orchestrator steadily chews through it without constant supervision.

We're not there yet, but the 30-hour unsupervised runs are a promising sign.

---

*Co-authored by Mike Greenly and Claude Code*

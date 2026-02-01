---
title: "Implementing /pin and /unpin"
slug: "real-development-session-pin-unpin"
published: 2026-01-25
republished: []
last_build_hash: ""
last_build_lines: 0
---

## A real development session

We recorded a full development session implementing the `/pin` and `/unpin` commands. Seven hours, unedited. This post walks through what happened and links to key moments in the video.

This didn't go smoothly, which is exactly why it's worth sharing.

## What We Were Building

Pinned documents are markdown files that get included in every LLM request. They form a layered, constructable system prompt. The `/pin` command adds a document to this list. `/unpin` removes it. Simple interface, but the implementation touches persistence, agent forking, session replay, and the system prompt assembly.

We'd discussed pinned documents in [a previous post](/posts/what-is-ikigai/) as a coming feature. This session was the implementation.

## The Workflow

Our development process has three phases that repeat:

1. **Interactive planning** with Claude to define the goal
2. **Ralph loop** runs autonomously until the goal is met (or it gets stuck)
3. **Manual verification** to check what actually works

The ralph loop handles implementation. Manual verification catches what the automated harness misses. When gaps appear, we write a new goal and run ralph again.

## Phase 1: Interactive Planning

[https://youtu.be/VU9GEmV9qfU?t=10](https://youtu.be/VU9GEmV9qfU?t=10)

We spent about 53 minutes in conversation with Claude defining what `/pin` and `/unpin` should do. This isn't typing a one-line prompt. It's a back-and-forth where we work out the details: How should paths work? What about `ik://` URIs? How does this interact with `/fork`? What happens on session replay?

The output is a goal file that captures everything ralph needs to know. The goal includes acceptance criteria, edge cases, and how the feature fits with existing code.

Plan review: [https://youtu.be/VU9GEmV9qfU?t=3192](https://youtu.be/VU9GEmV9qfU?t=3192)

## Phase 2: Ralph Runs

### Ralph #1: The Long Haul

The first ralph run took 10 iterations. Each iteration, the agent works toward the goal, runs the harness scripts to validate, and reports progress. Ralph accumulates this progress and feeds it into the next iteration.

  - **Loop 1:**  [https://youtu.be/VU9GEmV9qfU?t=3364](https://youtu.be/VU9GEmV9qfU?t=3364)
  - **Loop 2:**  [https://youtu.be/VU9GEmV9qfU?t=3575](https://youtu.be/VU9GEmV9qfU?t=3575)
  - **Loop 3:**  [https://youtu.be/VU9GEmV9qfU?t=3770](https://youtu.be/VU9GEmV9qfU?t=3770)
  - **Loop 4:**  [https://youtu.be/VU9GEmV9qfU?t=3956](https://youtu.be/VU9GEmV9qfU?t=3956)
  - **Loop 5:**  [https://youtu.be/VU9GEmV9qfU?t=4224](https://youtu.be/VU9GEmV9qfU?t=4224)
  - **Loop 6:**  [https://youtu.be/VU9GEmV9qfU?t=4884](https://youtu.be/VU9GEmV9qfU?t=4884)
  - **Loop 7:**  [https://youtu.be/VU9GEmV9qfU?t=6257](https://youtu.be/VU9GEmV9qfU?t=6257)
  - **Loop 8:**  [https://youtu.be/VU9GEmV9qfU?t=8488](https://youtu.be/VU9GEmV9qfU?t=8488)
  - **Loop 9:**  [https://youtu.be/VU9GEmV9qfU?t=10085](https://youtu.be/VU9GEmV9qfU?t=10085)
  - **Loop 10:**  [https://youtu.be/VU9GEmV9qfU?t=11673](https://youtu.be/VU9GEmV9qfU?t=11673)
  - **Manual verification:**  [https://youtu.be/VU9GEmV9qfU?t=11797](https://youtu.be/VU9GEmV9qfU?t=11797)

Ten iterations over two and a half hours. The harness said everything passed. Manual testing found gaps.

The primary issue was replay. When ikigai starts up, it reconstructs agent state by replaying events from the database, similar to how a database replays its write-ahead log. The problem: ikigai has two replay systems that work differently, and the initial goal didn't articulate the distinction clearly enough.

**Message replay** respects clear boundaries. If you run `/clear`, the replay only goes back to that clear event. This is what you'd expect for conversation history.

**Pin replay** ignores clear boundaries entirely. Pins should persist even after you clear your conversation. You want to keep your pinned documents even when starting fresh.

The agent kept trying to implement pin replay using the same boundary logic as message replay. It took several iterations before the architecture became clear: pins need their own independent replay pipeline that walks all pin/unpin commands regardless of clears. The final implementation in `agent_restore_replay_commands.c` queries ALL pin/unpin events for an agent, ignoring any clear events in between.


### Ralph #2: Addressing Gaps

  - Loop 1: [https://youtu.be/VU9GEmV9qfU?t=13125](https://youtu.be/VU9GEmV9qfU?t=13125)
  - Loop 2: [https://youtu.be/VU9GEmV9qfU?t=13778](https://youtu.be/VU9GEmV9qfU?t=13778)
  - Loop 3: [https://youtu.be/VU9GEmV9qfU?t=15194](https://youtu.be/VU9GEmV9qfU?t=15194)
  - End: [https://youtu.be/VU9GEmV9qfU?t=16880](https://youtu.be/VU9GEmV9qfU?t=16880)
  - Manual verification: [https://youtu.be/VU9GEmV9qfU?t=16928](https://youtu.be/VU9GEmV9qfU?t=16928)


### Ralph #3

  - Loop 1: [https://youtu.be/VU9GEmV9qfU?t=18253](https://youtu.be/VU9GEmV9qfU?t=18253)
  - End: [https://youtu.be/VU9GEmV9qfU?t=20224](https://youtu.be/VU9GEmV9qfU?t=20224)
  - Manual verification: [https://youtu.be/VU9GEmV9qfU?t=20295](https://youtu.be/VU9GEmV9qfU?t=20295)


### Ralph #4

  - Loop 1: [https://youtu.be/VU9GEmV9qfU?t=21963](https://youtu.be/VU9GEmV9qfU?t=21963)
  - End: [https://youtu.be/VU9GEmV9qfU?t=22723](https://youtu.be/VU9GEmV9qfU?t=22723)
  - Manual verification: [https://youtu.be/VU9GEmV9qfU?t=23032](https://youtu.be/VU9GEmV9qfU?t=23032)


### Ralph #5

  - Loop 1: [https://youtu.be/VU9GEmV9qfU?t=23344](https://youtu.be/VU9GEmV9qfU?t=23344)
  - End: [https://youtu.be/VU9GEmV9qfU?t=25069](https://youtu.be/VU9GEmV9qfU?t=25069)
  - Manual verification: [https://youtu.be/VU9GEmV9qfU?t=25127](https://youtu.be/VU9GEmV9qfU?t=25127)


## What This Shows

Five ralph runs. Sixteen total iterations. Seven hours.

The automated harness catches a lot. Compilation errors, test failures, coverage gaps, sanitizer warnings. But it can't catch everything. Manual verification matters. The loop isn't "run once and done." It's "run, verify, identify gaps, run again."

This is what agentic development actually looks like. Not a magic wand that writes features in one shot. A tool that does the implementation work while you guide the direction. The agent handles the volume. You handle the judgment.

The feature shipped. It works. The pinned documents system now lets you construct exactly what context the LLM sees on every turn. But getting there took iteration, not automation.

---

*Co-authored by Mike Greenly and Claude Code*

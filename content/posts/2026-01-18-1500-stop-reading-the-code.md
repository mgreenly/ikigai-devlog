---
title: "Stop Reading the Code"
slug: "stop-reading-the-code"
published: 2026-01-18
republished: []
last_build_hash: ""
last_build_lines: 0
---

I told a coworker recently: "With AI, if you're looking at the source code, you're doing it wrong."

That's a bit hyperbolic today, but I genuinely think it will be true for me before 2026 ends.

## The Shift

The point isn't about never reading code. It's about where you spend your time. Right now, I'm putting all my effort into improving how quickly AI turns my instructions into working code and how clearly I can describe what I want. The goal is simple: I should never have to check the code twice for the same issue.

Finding use-after-free bugs? Not my job anymore. That's what the tools are for.

## The Snowball Effect

I'm starting to feel real momentum from this approach. As the quality harnesses and automation catch more mundane issues, development accelerates. The problems that do surface are increasingly unique - things the automated checks haven't seen before.

Each improvement to the quality harness means fewer common bugs slip through. The issues that remain are more interesting and more specific to what we're actually building.

## What This Means

This isn't about being lazy or skipping code review. It's about optimizing where human attention goes. Instead of hunting for null pointer dereferences or off-by-one errors, you're focused on:

- Articulating requirements clearly
- Designing better quality checks
- Solving novel problems
- Building features

The mundane bugs get caught by automation. Your time goes to things that actually require human judgment.

## What's Next

There are layers to making this work - quality harnesses, test automation, prompting strategies, tool selection. We'll dig into these in future posts as we explore what actually works in practice.

For now, the key insight is this: the less time you spend reading generated code looking for bugs, the more time you have to build things. The trick is building systems you can trust to catch those bugs for you.

---

*Co-authored by mgreenly and Claude*

---
title: "The Ghost in the Machine Has Amnesia"
slug: "the-ghost-in-the-machine-has-amnesia"
published: 2026-03-08
republished: []
last_build_hash: ""
last_build_lines: 0
---

An AI agent that can't remember what worked yesterday will confidently break working code today. We hit a bug this week that perfectly illustrates why memory is the next frontier for agentic development, and why solving it matters more than making models smarter.

## The Bug

We implemented support for Anthropic's adaptive thinking (extended thinking / reasoning) about five or six weeks ago. It worked. We shipped it, moved on, and it kept working through multiple releases. Recently we started building context window management: sliding windows and conversation summaries so Ikigai can handle long sessions without blowing past token limits.

Then, out of nowhere, every adaptive thinking request started returning HTTP 400 errors.

Claude immediately zeroed in on the adaptive thinking implementation. That was the code path failing, so naturally that's where the bug must be. It started pulling apart the request formatting, checking parameter names, reviewing the API spec. An hour of confident, methodical debugging aimed at code that hadn't changed in weeks.

The problem was that Claude had no memory of those weeks. It couldn't easily recall that adaptive thinking had been stable for over a month. All it saw was a failing request and the code responsible for building that request. Without historical context, the most obvious hypothesis (the code generating the failing request is broken) looked like the right one.

## The Actual Problem

The real bug had nothing to do with adaptive thinking. We had just gotten conversation summaries working. Our implementation stored summaries as cacheable system blocks in the API request. That was the correct approach for the content itself, but Anthropic's API enforces a limit of four cacheable system blocks per request. Once summaries started flowing, the total count of cached system blocks pushed past that limit, and the API rejected the entire request.

Adaptive thinking was collateral damage. The HTTP 400 errors pointed at it because it happened to be part of the same request, but the root cause was an unrelated feature that had just started working correctly for the first time.

## Why Memory Matters

A human developer who had been on the project for six weeks would have caught this faster. They would have thought: "Adaptive thinking has been fine for weeks. What changed recently?" That question immediately points at the summary work, which was the only new behavior in the system.

Claude couldn't ask that question because it didn't have that context. Every session starts fresh. It can dig through git history, but that's archaeology, not memory. There's a difference between being able to reconstruct what happened and actually knowing what happened. One takes minutes of deliberate investigation. The other takes a fraction of a second of pattern matching against lived experience.

This isn't a one-off problem. We've seen variations of it multiple times. The agent fixates on whatever is directly in front of it because it has no broader timeline to reason against. When the failing code and the broken code are in different parts of the system, and the connection only makes sense if you know the project's recent history, stateless debugging becomes a trap.

## The Path Forward

We're already working on better memory systems for Ikigai. Persistent context that survives across sessions, project history that the agent can query naturally, summaries of recent work that give it a sense of what changed and when. The irony is that the very feature we were building when we hit this bug (conversation summaries) is part of that solution.

The industry conversation around AI capabilities focuses heavily on reasoning, context windows, and tool use. Those matter. But an agent that reasons brilliantly about the wrong problem is worse than a mediocre reasoner pointed at the right one. Memory is what points you at the right problem. It's the difference between a contractor who shows up every day with no idea what happened yesterday and a teammate who remembers the arc of the project.

We're four months into building Ikigai, and improving the agent's ability to retain and access history feels like the highest-leverage work we can do next. Not because the models aren't smart enough. Because smart isn't useful without context.

*Co-authored by Mike Greenly and Claude Code*

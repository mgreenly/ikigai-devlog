---
title: "Get Out of the Way"
slug: "get-out-of-the-way"
published: 2026-03-15
republished: []
last_build_hash: ""
last_build_lines: 0
---

The more we remove ourselves from the execution path, the better the work gets. We [stopped reading the code](/posts/stop-reading-the-code/). [Ditched the pull request](/posts/ditching-the-pull-request/). [Killed the backlog](/posts/the-backlog-is-dead/). Each time we peeled away a layer of human involvement that felt essential, the work flowed smoother. Now we're starting to wonder how much further that principle extends.

## The Bitter Lesson, Loosely Applied

Rich Sutton's [The Bitter Lesson](https://en.wikipedia.org/wiki/Bitter_lesson) argued that brute-force computation always beats hand-crafted human expertise in AI. It's "bitter" because it means getting out of the machine's way works better than teaching it how to think.

We're seeing the same dynamic in agentic development. Agent work is cheap and parallel. Stop organizing it like a human team. Point agents at goals, give them tools, let them iterate. That's the ralph-loop, and it works.

## The Process Frameworks

Other projects are going the opposite direction. [Gas Town](https://github.com/steveyegge/gastown) assigns named roles to agents (Mayors, Polecats, Refineries). [BMAD](https://github.com/bmad-code-org/BMAD-METHOD) defines twelve specialized personas that collaborate through a structured agile cycle.

They all encode human process into agent orchestration. We [tried that too](/posts/the-pivot/), building toward orchestrated hierarchies where agents would coordinate mid-task. The evidence pushed us away from it.

The agents writing goals and the agents executing them are equally capable. The only reason we stay involved in goal creation is human alignment, deciding what to build and why. Once that's settled, the ralph-loop takes over. The goal goes in, an agent iterates in isolation, and a result comes out. No special roles, defined phases, or handoffs. Execution doesn't need us. We verify the results, but we don't guide the work.

## The Pipeline Is the Product

Ikigai felt like the center of the system. theRALPHs started as Claude Code tooling, a way to explore the space so we'd know how to build Ikigai's pipeline. The original goal was to build that pipeline into Ikigai. We didn't expect it to become external and agent-agnostic.

But as we wrote [yesterday](/posts/the-ralphs-dont-need-ikigai/), theRALPHs don't need Ikigai. The pipeline is a standalone system that doesn't care which client submitted the work. Ikigai is one interface. The Claude Code plugin is another. Anything that can write a goal could be a third.

That reframing changes what Ikigai needs to be. It doesn't need to orchestrate anything. It needs to be a great conversational interface for thinking through problems, decomposing goals, and reviewing results. It needs access to all the history, context, documents, and repos. But the execution, the actual building, that happens in the pipeline regardless of how you talk to it.

## The Interface Doesn't Matter

If the pipeline is the real engine, any interface should be able to drive it. Message it from your phone, kick off a goal from Slack, review results through a web dashboard. That's where Ikigai is heading. Not a pipeline, but the best client for serious software development.

## From Features to Applications

The pipeline nails feature-sized goals like adding GPT-5.4 support or implementing token cache invalidation. Well-scoped, testable, completable in a single ralph session. The next experiment is giving the pipeline a release or an application as the goal, not a feature.

We don't know how that works yet, but we have a hunch. When the cost of writing code approaches zero, the best way to make decisions about software might be to just build several versions and see which one works. Instead of refining requirements through conversation, the agent builds rough implementations and you react to working software. Thumbs up, thumbs down, and keep refining the best ideas.

## Getting Out of the Way

None of this is built yet. But it's where the lessons keep pointing. Get out of the agents' way. Our job is defining what we want, sometimes through conversation, sometimes by reacting to experiments. Stop telling them how to do the work. It slows them down and buries the signal in our noise.

*Co-authored by Mike Greenly and Claude Code*

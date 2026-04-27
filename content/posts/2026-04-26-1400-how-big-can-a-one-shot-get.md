---
title: "How Big Can A One-Shot Get?"
slug: "how-big-can-a-one-shot-get"
published: 2026-04-26
republished: []
last_build_hash: ""
last_build_lines: 0
---

Pretty much everything we build to make agents work better has a shelf life of a few months. Each model release brings more tokens, more capability, and better subagent orchestration, which keeps eroding whatever harness or process we built to compensate for the previous generation. Whatever we ship fills a gap until the next release makes it unnecessary. Spec-driven systems like [BMAD](https://github.com/bmad-code-org/BMAD-METHOD) and [github-speckit](https://github.com/github/spec-kit) feel like they fit the same pattern. Useful right now, probably obsolete soon. The real question is what a spec should even look like once the underlying model can do more on its own.

That led to an experiment. We're trying to find the largest application we can one-shot correctly with Opus 4.7 and GPT-5.5, using nothing but natural language as the spec. We didn't start with a methodology or template. The spec is consistent inside the project because we worked one out on the fly with the designer, but it isn't an attempt at a generalized system.

## The Setup

Two agents. The co-designer holds the spec. We build it interactively, one major feature at a time. When a feature is ready, we hand the whole spec to the builder and ask it to one-shot the application from scratch. Every previous build gets deleted before the next run starts. The builder never sees its own prior work.

After the build finishes, we conduct an exit interview with the builder. What was ambiguous? What did the spec assume? Where did it have to guess? That report goes back to the co-designer. Sometimes that turns into a conversation, sometimes it doesn't, but the spec gets revised either way. Then I run the implementation as a QA engineer would. The designer can't help at this stage, it's just me poking at the build and writing down what's wrong. Those notes go back to the designer afterward to reinforce the spec where things broke. Then we describe the next feature.

Each iteration of the spec absorbs three signals: builder feedback, QA feedback, and the next feature.

## The Numbers

A single build is around 200k tokens at the top level, with twelve or more subagents spending 150k to 250k each. Wall clock started as low as ten minutes on iteration one and is now around four hours and twenty minutes. The spec is 60k lines across roughly 50 files. Each run produces around 600 tests against the implementation.

The top-level agent's token spend isn't growing much. As the application gets larger, the surface for parallelism grows instead. Early runs spawned four subagents. Now it's twelve plus. My gut says that we're about a third of the way to the actual ceiling, but that's pure speculation.

## What We're Building

The application is an AD&D 2e play aid, similar in spirit to D&D Beyond. Character creation, equipment, spells, the buy and sell loop. I picked AD&D 2e on purpose. It has enough rules, modifiers, and bookkeeping to give the spec real surface area, which is exactly what a one-shot needs to be tested against. The combat simulator is what's coming next.

The app has real scope at this point. Each build picks its own stack. One run lands in JavaScript, the next in Python. A few choices show up regularly without being prescribed, SQLite and server-side rendering most of all. Server-side rendering probably wins so often because the app is static content heavy. Otherwise the builds genuinely differ.

## Why This Isn't A Development Strategy

You can't ship one of these to production and put the next iteration on top. Naming, structure, framework choice, all of it shifts between runs. Nobody should run a real project this way.

The experiment is still worth doing, because of what we're learning along the way.

The ceiling is much higher than we'd assumed. Exit interviews are surprisingly precise about where the spec is vague. Most of what we've learned about how to slice a spec for parallel execution came from the builder's feedback, not from us guessing. We've learned more about what a spec needs to contain by reading exit interviews than by writing any methodology.

## Some Early Takeaways

Whatever spec system we eventually settle on has to be iterative. A four hour rebuild cycle isn't viable for normal development. But the ability to rebuild from a clean spec, even occasionally, has value. Exit interviews from a one-shot build surface things an iterative project never sees, because the codebase quietly carries the answers the spec should have stated explicitly.

Even if the day-to-day workflow stays incremental, running a clean rebuild as a background tool just to harvest the exit interview might be one of the better ways to keep a spec honest.

The experiment isn't finished. Conclusions will shift. But that's where the thinking is right now.

*Co-authored by Mike Greenly and Claude Code*

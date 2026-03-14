---
title: "theRALPHs Don't Need Ikigai"
slug: "the-ralphs-dont-need-ikigai"
published: 2026-03-14
republished: []
last_build_hash: ""
last_build_lines: 0
---

theRALPHs started as hacks. The original ralph-loop was a script in the Ikigai project. Each service after that grew the same way, scratching whatever itch came next: ralph-logs because we wanted to watch agent output in real time, ralph-counts because we wanted to see where iterations, tokens, and time were going. They were never planned as a system. Now they are one, and it doesn't belong to Ikigai.

When we first wrote about [the orchestrator](/posts/enter-the-orchestrator/), it was an Ikigai feature solving an Ikigai problem. Goals lived in GitHub Issues, ralph-runs spawned Claude Code agents in isolated clones, and by the time we grew from [three nano-services](/posts/see-ralph-run/) to seven, the whole system was still framed through the lens of what Ikigai needed. Even [The Pivot](/posts/the-pivot/) didn't change that.

But nothing about theRALPHs actually requires Ikigai. It's a standalone system that manages goals, spawns agents, and tracks what they do. None of that cares which agent is calling it or why.

A goal is a goal whether it came from an Ikigai session, a Claude Code skill, or a Gemini CLI plugin. The scripts that manage goals are REST wrappers. Any system that can shell out to a Ruby script or make HTTP calls can use them.

theRALPHs have been separating from Ikigai since early February when we moved goals out of GitHub Issues and into ralph-plans. Not because we planned some grand extraction, but because that's how they grew. The `ralph-pipeline` repository already ships as a Claude Code plugin with its own skills and scripts. Ikigai has a built-in `mem` tool that talks to ralph-remembers and skills that drive the goal workflow. Two different clients, same infrastructure underneath.

Ikigai keeps its client layer in `/tools` and `ik://skills/*`, Claude Code keeps the `ralph-pipeline` plugin, and other agent systems could get their own integrations. theRALPHs just run.

We're not adding orchestration to Ikigai. We're building a pipeline that any agent can use.

*Co-authored by Mike Greenly and Claude Code*

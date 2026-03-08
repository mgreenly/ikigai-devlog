---
title: "The Backlog Is Dead"
slug: "the-backlog-is-dead"
published: 2026-03-06
republished: []
last_build_hash: ""
last_build_lines: 0
---

OpenAI shipped new models yesterday. Today I sat down, described what we needed, and ten minutes later an agent had researched the API changes, audited our codebase, and queued a goal to implement support. Ten minutes isn't instant, but it's fast enough that the work never had time to become a backlog item. There was no ticket to file, no grooming session to sit through.

We've been noticing this pattern for weeks. We plan Ikigai in milestone releases, not sprints, and we track goals in the Ralph pipeline rather than a traditional backlog. But even within that lightweight structure, work that would normally wait for the next planning session just gets done. The bottleneck isn't implementation capacity anymore. It's deciding what to implement. And once you decide, there's nothing left to queue.

## The Conversation

Here's the actual session, lightly edited. I started with a loose prompt. I knew OpenAI had released GPT-5.4 models but hadn't looked at the details yet.

> **Mike:** OpenAI has recently released a number of new models in the GPT 5.4 family. Use a team of agents to research the details online. Research if there are any OpenAI API changes that we need to support to use these models. Is there any changes we need to make to our code structure to support these? Once you have all the details we can discuss preparing a goal to implement support.

No model IDs, no API docs, no file paths. Just "new models exist, figure out what we need to do."

Claude launched three research agents in parallel: one searching for the new model details, one checking for API changes, and one auditing our existing OpenAI provider code. Seconds later, the consolidated report came back with model IDs, context windows, pricing, and API compatibility for both GPT-5.4 and GPT-5.4 Pro. No breaking API changes. Our architecture is table-driven, so adding the new models is a registration-only change. The agent identified the exact files and line numbers where entries needed to be added, and spotted a model we'd missed entirely (GPT-5.3 Codex had shipped earlier without us noticing).

Then it asked: "Want me to prepare the goal now?"

> **Mike:** Yes, let's be sure to add the additional e2e tests, like those that exist for the current models, and to update the user-facing documentation to reflect the changes.

More research agents launched to examine our test patterns and documentation structure. Claude created goal #306, covering code changes, e2e tests, and documentation updates, and queued it for execution in the Ralph pipeline.

From "OpenAI shipped new models" to "goal queued and ready for an agent to execute," the whole thing took minutes.

## What Didn't Happen

Nobody filed a ticket. Nobody estimated story points. Nobody scheduled a sprint. Nobody groomed a backlog.

All of that machinery exists to manage a queue of work waiting for human implementation capacity. The backlog is a buffer between "we know what to do" and "someone is available to do it." When an agent can pick up the work immediately, the buffer serves no purpose.

## Not Just the Easy Stuff

Adding model entries to lookup tables isn't hard. But the agent didn't just add entries. It researched models it had never seen before, cross-referenced API docs against our C codebase, identified exact registration points, noticed a model we'd missed, proposed effort mappings based on patterns from previous models, and structured a goal covering code, tests, and docs. That's an hour of developer context-gathering compressed into a conversation.

This pattern works for surprisingly complex changes too. We've used the same flow for architectural decisions, multi-file refactors, and features that touch several subsystems. The complexity ceiling keeps rising.

## The Shift

Traditional development has a pipeline: ideas become tickets, tickets get prioritized, priorities get scheduled, schedules get assigned, assignments get implemented. Each stage exists because there's a gap between wanting something done and having the capacity to do it. The backlog is the queue where work waits for that capacity.

When implementation capacity is effectively unlimited (or at least dramatically cheaper and faster), the pipeline compresses. Ideas become conversations. Conversations become goals. Goals become code. The intermediate stages, the tracking, the prioritizing, the scheduling, all of it was managing scarcity that no longer exists.

We're not saying project management disappears. Someone still needs to decide what to build and in what order. Product thinking, architectural vision, user empathy, those are more important than ever. But the mechanical overhead of translating decisions into tracked, scheduled, assigned units of work? That's the part that's evaporating.

The backlog was never the point. It was a coping mechanism for limited implementation bandwidth. When that constraint lifts, you don't need a better backlog. You need to stop thinking in terms of backlogs entirely.

---

*Co-authored by Mike Greenly and Claude Code*

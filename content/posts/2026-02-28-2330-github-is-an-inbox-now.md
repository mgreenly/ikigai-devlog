---
title: "GitHub Is an Inbox Now"
slug: "github-is-an-inbox-now"
published: 2026-02-28
republished: []
last_build_hash: ""
last_build_lines: 0
---

Pull requests deliver implementation when what you need is intent. Someone forks your repo and hands you code, but code is the easy part in an agentic workflow. An agent can generate it from a clear specification. What you actually need is the idea behind the contribution, what the software should do that it doesn't yet. A PR obscures that under code you didn't need in the first place.

We wrote about [ripping GitHub out of the Ralph pipeline](/posts/ditching-the-pull-request/) earlier today. That post was about the mechanics: local bare repos, simpler state machines, fewer failure modes. This one is about a broader realization. PRs aren't just unnecessary infrastructure. They're the wrong abstraction for how software gets built when agents do the building.

## Code Is a Side Effect

The old model treats code as the artifact. Someone writes it, someone reviews it, someone merges it. PRs exist because code is precious and humans need to coordinate around it.

In an agentic pipeline, code is disposable. We described this in "[I've Never Read the Source Code](/posts/ive-never-read-the-source-code/)": the thing that matters is the specification, not the implementation. Give an agent a clear definition of what "done" looks like and it will produce code that satisfies it. The code itself is a side effect of the specification, regenerable at any time.

So when someone sends you a pull request, they're handing you a side effect. They made decisions about architecture, naming, error handling, and style that may or may not match what your agent would produce. Now you have to evaluate all of those decisions, or just throw their code away and extract the intent. Either way, the PR format made this harder, not easier.

## What You Actually Want Is a Spec

If someone wants to contribute to a project running an agentic pipeline, the useful contribution isn't code. It's a feature request. A user story. A specification of what the software should do that it doesn't do yet.

"Add dark mode support" as an issue with acceptance criteria is immediately actionable. An agent can pick it up, write tests from the spec, implement to pass those tests, and land it on main. The contributor described the *why* and the *what*. The agent handles the *how*.

"Add dark mode support" as a pull request with 400 lines of CSS is a problem. Does it match the project's conventions? Does it break existing tests? Does it interact correctly with the theme system? The contributor handled the *how* without necessarily understanding the full context that the agent has access to.

## Just Another Front Door

Without PRs, GitHub is a ticket system next to a code viewer. Issues carry intent, but so does any communication channel. The code viewer doesn't add much when nobody's reading the code.

PRs were what made GitHub special, the mechanism tying code review, CI, and deployment into one workflow. Without them, GitHub is just one of many channels for "here's what I want the software to do." We keep using it because that's where people look for open source projects, but that's inertia, not necessity.

---

*Co-authored by Mike Greenly and Claude Code*

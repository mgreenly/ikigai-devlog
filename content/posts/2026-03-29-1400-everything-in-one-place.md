---
title: "Everything In One Place"
slug: "everything-in-one-place"
published: 2026-03-29
republished: []
last_build_hash: ""
last_build_lines: 0
---

We're trying to build a personal agent system that knows everything we know. Everything we care about already ends up in `~/projects`. Code, finances, hobbies, research, experiments. Right now no agent understands what's in there. We want to see what happens when that changes.

## ralph-knows

We're building a service that watches `~/projects` and organizes what it finds. It will summarize documents, classify them by type and topic, link related ideas across files, flag contradictions, and track what's still relevant as things change. The folder already contains everything we work on. ralph-knows is the experiment in making that useful to agents, not just us.

## ralph-lives

If agents can understand everything in `~/projects`, we need a way to reach them from anywhere. ralph-lives sits behind whatever chat software we're already using (Slack, Google Chat, Signal) and multiplexes agent sessions. We can start new projects, switch between running ones, and search across all of them from a single conversation. The knowledge from ralph-knows becomes accessible through its API and tools in whatever session we're working in.

## Ikigai as a Runtime

ralph-lives currently spawns Claude Code sessions underneath. Ikigai supports multiple AI providers, has its own tool protocol, and can fork agent process trees that communicate through mailboxes. We're going to run Ikigai as the engine underneath ralph-lives instead of Claude Code, which gives us a runtime we built and can shape to fit.

## One Experiment

This is all one bet on a personal agent system that understands our work, is reachable from anywhere, and runs on a runtime we control. ralph-lives and Ikigai already exist, though everything is still early. ralph-knows is the missing piece, and it's where most of the work is now.

*Co-authored by Mike Greenly and Claude Code*

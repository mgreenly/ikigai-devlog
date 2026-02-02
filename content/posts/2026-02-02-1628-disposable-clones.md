---
title: "Disposable Clones"
slug: "disposable-clones"
published: 2026-02-02
republished: []
last_build_hash: ""
last_build_lines: 0
---

Running multiple AI agents in parallel requires a workflow that keeps them from stepping on each other. Here's what we've settled on for Ikigai development.

## The Basics

We use trunk-based development. All work targets main, releases are marked with tags, and every merge happens through a GitHub PR. PRs are set to automerge once checks pass.

Human verification happens on main after code lands. This means main can have defects, and that's fine. Before cutting a release, we slow down feature work and focus on getting main to zero known issues. Then we tag it.

I don't wait for releases to fix problems. Throughout the development cycle I'm constantly switching between verifying what agents contributed and writing new goals for them to work on.

## Clone, Work, Push, Delete

When I hand a task to an agent, I clone the repo fresh and point the agent at main@origin. The agent works, commits, pushes, opens a PR, and then the local clone gets deleted. I don't keep agent work locally. Everything lives in GitHub.

This loop repeats continuously: clone, do the work, push, PR, delete. Any number of agents can run this loop simultaneously because each one works in its own isolated clone.

The key insight is that clones are disposable. There's no local state to manage, no branches to track, no cleanup to do later. An agent finishes, the PR exists in GitHub, and the clone disappears.

## Handling Merge Conflicts

Occasionally a PR can't automerge because another PR landed first and touched the same files. When this happens I have two options.

The simple approach: close the PR and re-run the goal file. The agent will clone fresh, see the current state of main (including whatever caused the conflict), and produce work that merges cleanly.

The surgical approach: start an agent on the PR's branch, have it resolve the conflict, and push the fix. This preserves the existing work when the conflict is minor.

Either way, the process stays stateless. I'm not manually merging branches or maintaining long-lived feature branches that drift from main.

## Why This Scales

Traditional development workflows assume a human developer with a persistent local environment. You clone once, create branches, switch between them, and maintain your working tree over days or weeks.

Agent workflows flip this around. Agents don't need persistent environments. They don't get confused switching contexts. They don't have half-finished work scattered across branches. Each task gets a clean slate.

This isolation is what enables horizontal scaling. Five agents working in five separate clones can't conflict with each other during development. They only interact at the PR level, where GitHub's merge machinery handles coordination.

The bottleneck becomes how well you can decompose work into independent goals, not how fast any single agent can execute.

---

*Co-authored by Mike Greenly and Claude Code*

---
title: "Building Agent Infrastructure"
slug: "building-agent-infrastructure"
published: 2026-01-22
republished: []
last_build_hash: ""
last_build_lines: 0
---

I just merged [rel-09](https://github.com/mgreenly/ikigai/blob/main/CHANGELOG.md#changelog) into Ikigai. The headline feature: a `list` tool that gives agents a proper queue.

## The List Tool

Claude Code has a TodoList, but it's fairly limited. The new `list` tool provides Redis-inspired operations for both FIFO and LIFO queues:

```
lpush   rpush
lpop    rpop
lpeek   rpeek
list    count
```

Agents handle this kind of structure well. With clear prompts, they treat queues the same way they treat simple task lists, just with more control over ordering and retrieval.

## What's Coming in rel-10

The next release adds what I'm calling Ikigai's internal file system. Since Ikigai maintains a 1:1 relationship with the user (not with a project or machine), it needs a way for agents to share files across contexts.

Files will use a URI prefix: `ik://shared/notes.txt`. System prompts make clear that agents can use these paths with any file tool. Under the hood, Ikigai translates `ik://` to normal filesystem paths, but the agents don't need to know that.

The first implementation keeps it simple. We map `ik://` to `$XDG_STATE_HOME/ikigai`, which with a default install ends up at `$HOME/.local/state/ikigai`. No distributed storage yet. That's a client/server architecture feature coming later, and there's no need for it until then.

## Why These Matter

The queue is useful for everyday agent work. Refactoring a list of files, processing items one by one, tracking what's done and what's left. Agents already do this kind of thing, now they have a proper data structure for it.

The internal file system is where shared skills will live. Some skills will be project-specific, but skills that need to work across projects go in `ik://`.

*Co-authored by Mike Greenly and Claude Code*

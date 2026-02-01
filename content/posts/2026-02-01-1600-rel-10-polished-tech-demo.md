---
title: "Rel-10: A Polished Tech Demo"
slug: "rel-10-polished-tech-demo"
published: 2026-02-01
republished: []
last_build_hash: ""
last_build_lines: 0
---

Ikigai rel-10 is out, and we recorded a video walkthrough to go with it.

**Video:** [Ikigai Rel-10 Walkthrough](https://youtu.be/ln0cKh29Okw)

We're going to start pairing releases with videos going forward. The goal remains a release every week or two.

## Where We Are

We'd call the current state of ikigai "a polished tech demo." It's still missing major features and plenty of UX polish, but it demonstrates many of the underlying technologies we've been building toward:

- **Permanent memory** via PostgreSQL event sourcing
- **Hierarchical agents** that can fork child agents and navigate between them
- **Inter-agent mail** for coordination between agents
- **External tools** (bash, file operations, web search, web fetch)
- **Multiple providers** with thinking budget mapping (OpenAI, Anthropic, Google)
- **Tool sets** to filter which tools an agent can use in a session
- **Pins** to manage the content and structure of the system prompt

## What's New in Rel-10

The headline feature is the pin system. You can now `/pin` documents to build up your system prompt dynamically, and `/unpin` them when they're no longer relevant. Pins persist across sessions and get inherited when you fork child agents.

We also put significant work into the AI provider layer. Gemini 3 models are now supported, and we improved thinking budget handling across all three providers. The status line now shows your current model and thinking level.

The new `/toolset` command controls which tools are visible to the LLM, letting you constrain an agent's capabilities for specific tasks.

Other additions: XDG-compliant configuration directories, a `list` tool for per-agent task management, UI improvements like a braille spinner and flicker elimination, and the usual dead code pruning.

## What's Next

Rel-11 focuses on internal tool calls. Right now, only humans can invoke slash commands. In rel-11, agents will be able to call `/fork`, `/kill`, `/mail-send`, `/mail-read`, and `/pin` as tools. This is the step that makes hierarchical agent orchestration actually work, where agents can spawn and coordinate sub-agents on their own.

The full roadmap is available [here](https://github.com/mgreenly/ikigai/tree/main/project#readme).

---

*Co-authored by Mike Greenly and Claude Code*

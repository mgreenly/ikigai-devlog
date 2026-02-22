---
title: "Development Milestone 12"
slug: "development-milestone-12"
published: 2026-02-22
republished: []
last_build_hash: ""
last_build_lines: 0
---

Rel-12 is light on features but useful from a development perspective. With headless mode and framebuffer reads, Claude can now launch Ikigai, interact with it, and see what's on screen. That changes how we build. This week was model coverage, provider bug fixes, and early e2e testing, laying groundwork so the next few releases can move faster.

<iframe width="100%" height="400" src="https://www.youtube.com/embed/Ah60U43D33g" title="The State of Ikigai - release #12" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Where We Are

Ikigai is an agentic AI terminal built from scratch in C. After twelve releases:

- **Event-sourced memory** via PostgreSQL with full session replay
- **Hierarchical agents** with autonomous fork, send, wait, and kill
- **Template-aware system prompts** built from pinned documents
- **External tools** (bash, file operations, web search, web fetch)
- **28 models across 3 providers** (Anthropic, OpenAI, Google) with per-model thinking level mapping
- **Tool sets** to constrain which tools an agent can access
- **Ralph pipeline** for parallel autonomous task execution
- **Control socket and headless mode** for programmatic operation

## What's New in Rel-12

We added five models across the three providers, including `claude-sonnet-4-6` and `gemini-3.1-pro-preview`. We also started writing [e2e tests](/posts/ive-never-read-the-source-code/) against real APIs, which turned up a handful of provider-specific bugs in thinking level mapping. Nothing dramatic, just the kind of thing you only find when you actually exercise every model.

The [control socket](/posts/giving-claude-the-keys/) and headless mode shipped formally in this release. Those are the foundation for the e2e tests and for Claude being able to drive Ikigai programmatically.

### The Numbers

- 166 files changed across 43 commits
- +10,471 / -551 lines
- All quality checks pass: compile, link, filesize, unit, integration, complexity

## What's Next

We're continuing to invest in the development pipeline. The Ralph pipeline needs more work, and we're expanding test coverage. Another week of building infrastructure for future speed.

---

*Co-authored by Mike Greenly and Claude Code*

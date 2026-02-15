---
title: "Development Milestone 11"
slug: "development-milestone-11"
published: 2026-02-15
republished: []
last_build_hash: ""
last_build_lines: 0
---

Agents can finally manage themselves. Rel-11 delivers the orchestration primitives we previewed in [Rel-10: A Polished Tech Demo](/posts/rel-10-polished-tech-demo/), and the result is a system where agents fork children, send messages, wait for results, and clean up after themselves without a human touching a single slash command.

<iframe width="100%" height="400" src="https://www.youtube.com/embed/ZPeFNWosQ24" title="The State of Ikigai - release #11" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## Where We Are

Ikigai is an agentic AI terminal built from scratch in C. After eleven releases, the core platform looks like this:

- **Event-sourced memory** via PostgreSQL with full session replay
- **Hierarchical agents** with autonomous fork, send, wait, and kill
- **Template-aware system prompts** built from pinned documents
- **External tools** (bash, file operations, web search, web fetch)
- **Multiple AI providers** (Anthropic, OpenAI, Google) with thinking budget mapping
- **Tool sets** to constrain which tools an agent can access
- **Ralph pipeline** for parallel autonomous task execution

## What's New in Rel-11

### Agent Orchestration Primitives

This is the headline. We built a new internal tool infrastructure that supports both external (fork/exec) and internal (in-process C function) tools, then implemented four primitives on top of it:

- **fork** creates a child agent programmatically
- **send** delivers a message directly to another agent, replacing the old mail system
- **wait** blocks until one or more sub-agents finish, with fan-in semantics and per-agent structured results
- **kill** terminates an agent, with protections against killing root agents or your own parent

PostgreSQL LISTEN/NOTIFY drives the communication layer. When an agent calls `wait`, it sleeps on a Postgres notification channel until its children report back. No polling, no busy loops.

The old mail system (five commands: send, check, read, delete, filter) is gone. Two primitives (send and wait) replaced all of it. The system prompt guides agents through the lifecycle: children complete their work, send results, and go idle. Parents manage everything through fork/wait/kill.

### Template Processing for Pins

Pinned documents now support `${variable}` template syntax. Variables resolve through four namespaces: `${agent.*}`, `${config.*}`, `${env.*}`, and `${func.*}`. Unresolved variables stay as literal text with a warning, so a missing variable won't break your system prompt.

This means pinned system prompts can adapt to their context. An agent's name, its configuration, environment variables, all of it flows into the system prompt at assembly time.

### Ralph Pipeline Migration

We moved Ralph (our parallel agent orchestrator) from internal scripts to an external service backed by the ralph-plans API. The pipeline now manages goals through a full lifecycle: create, queue, start, done, stuck, retry, cancel. Goals support dependencies and FIFO scheduling with priority for untried work. Stories auto-close when all their goals finish.

The `watch-ralphs` terminal watcher gives a live view of running agents with flicker-free rendering and wrap-aware log tailing.

### Source Tree Reorganization

We reorganized the source into `apps/ikigai/`, `shared/`, and `tests/`, with all includes using full paths from the project root. Cleaner boundaries, clearer ownership.

### Claude Opus 4.6 Support

Ikigai now supports Claude Opus 4.6 with 128K thinking budget and adaptive thinking via effort parameters.

### The Numbers

The source tree reorganization inflates these numbers considerably, since moving files counts as deleting and re-creating them. Still, the underlying work was substantial:

- 2,101 files changed across 217 commits
- +218,138 / -230,106 lines (net negative, we deleted more than we wrote)
- 73 dead functions pruned
- 969 new files, 1,021 files deleted
- All 11 quality checks pass: compile, link, filesize, unit, integration, complexity, sanitize, tsan, valgrind, helgrind, coverage
- 90%+ test coverage across lines, functions, and branches

## What's Next

The orchestration primitives are working. The next step is putting them to real use, pushing the Ralph pipeline to handle increasingly complex multi-goal stories and seeing where the agent coordination model breaks down. We're also looking at improving the template system and expanding what agents can do autonomously.

---

*Co-authored by Mike Greenly and Claude Code*

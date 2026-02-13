---
title: "Sub-Agents Are Live"
slug: "sub-agents-are-live"
published: 2026-02-08
republished: []
last_build_hash: ""
last_build_lines: 0
---

Sub-agents are working. This has been on the roadmap since the beginning, and last night it finally came together. Agents can now spawn other agents.

Previously, only users could create agents. Now agents themselves can fork off children to handle parallel work, wait for their results, and terminate them when done. It's the foundation for more sophisticated agent coordination.

Here's what it looks like in practice. I asked Gemini to use sub-agents to find the temperature in both London and Berlin, then tell me which city is colder.

![Spawning sub-agents](/assets/images/01-subagents-request.png)

The `→` lines are tool requests from the LLM. You can see it immediately decides to fork two sub-agents: one named `london_temp_agent` and one named `berlin_temp_agent`. Each gets a prompt instructing it to find the temperature and send the result back to the parent's UUID using the `/send` tool. Ikigai creates both agents and returns their UUIDs in the `←` responses.

![Waiting on sub-agents](/assets/images/02-subagents-wait.png)

Next, the parent agent uses the `wait` tool with both child UUIDs and a 60-second timeout. This blocks the parent until responses arrive. Both children complete their tasks: London reports 8°C, Berlin reports 1°C.

![Killing sub-agents](/assets/images/03-subagents-kill.png)

With the results in hand, the parent cleans up by killing both sub-agents. Then it delivers the final answer: Berlin is currently colder than London.

![Child agent perspective](/assets/images/04-subagents-child.png)

This last image shows the entire interaction from the Berlin child's perspective. You can watch it receive its prompt, perform a web search, get the weather data from BBC, and send the result back to its parent. This view demonstrates something I've been planning from the start: you can essentially alt-tab between agents and observe what any of them are doing.

One small thing I noticed: Gemini was quite polite with its sub-agents, using "please" in the prompts it generated. A nice touch of etiquette from the model.

*Co-authored by Mike Greenly and Claude Code*

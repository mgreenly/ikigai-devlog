---
title: "I've Never Read the Source Code"
slug: "ive-never-read-the-source-code"
published: 2026-02-19
republished: []
last_build_hash: ""
last_build_lines: 0
---

I've never looked at Ikigai's source code. Not once. Fifteen weeks into a project with 1,100 files, 173,000 lines of C, and a custom terminal renderer, and I couldn't tell you what most of the functions are named. That's not neglect. It's the experiment.

## The Question

Early on it would have looked like Ikigai, the terminal-based coding agent, was the project. It sort of was. But there was always an unspoken second goal: figuring out how to get an LLM to build real software without a human ever reading the code. To run that experiment properly, we needed a complex target, something ambitious enough to stress-test an LLM-driven development pipeline. A coding agent fit perfectly. We could learn about building with AI agents by building an AI agent. Bootstrapping in the truest sense.

The concrete goal was always the same: figure out how to get an LLM to write software with minimal human input and zero human post-verification. Not 2x productivity. Not "copilot helps me type faster." We're talking about true 10x, 50x, maybe 100x amplification, where the human defines what the software should do and the machine builds it.

That framing has sharpened over time. What we're really trying to figure out is whether there's a reliable pipeline for this, and how to demonstrate that what comes out the other end actually works.

## The Insight

The answer turns out to be straightforward, at least in principle: if you can define every goal in a way that's deterministically verifiable, and you ensure every desired outcome has a definition, the result is provably complete. You don't need to read the code. You don't need to review pull requests. You need tests that prove the software does what it's supposed to do.

Follow that to its conclusion and it means the human's job shifts entirely from writing and reviewing code to writing specifications. I describe what should happen in plain language, Claude turns that into a rigidly defined test script, then writes the code to make it pass. User stories become the input. Everything else is automation.

## Making It Real

We just shipped the infrastructure to make this practical. In [Giving Claude the Keys](/posts/giving-claude-the-keys/), we described how Ikigai gained a control socket that lets an external process inject keystrokes and read the framebuffer. That was the missing piece. Now a test script (or an AI agent) can drive Ikigai from the outside exactly the way a human would: type commands, read the screen, verify the result.

The e2e test framework is declarative JSON. Each test defines steps (send keystrokes, wait, read the framebuffer, queue a mock response) and assertions (this text appears on screen, that text doesn't). The runner starts Ikigai in headless mode, connects to its control socket, and executes the sequence. No human eyes required.

Here's what an actual test looks like:

```json
{
  "name": "set model to anthropic claude-haiku-4-5 with low reasoning",
  "steps": [
    {"send_keys": "/clear"},
    {"wait": 1},
    {"send_keys": "\\r"},
    {"wait": 1},
    {"send_keys": "/model claude-haiku-4-5/low"},
    {"wait": 1},
    {"send_keys": "\\r"},
    {"wait": 1},
    {"mock_expect": {"responses": [{"content": "Mock response from claude-haiku-4-5."}]}},
    {"send_keys": "Hello"},
    {"wait": 1},
    {"send_keys": "\\r"},
    {"wait": 5},
    {"read_framebuffer": true}
  ],
  "assert": [
    {"contains": "claude-haiku-4-5/low"},
    {"contains": "Thinking: low"},
    {"line_prefix": "●"}
  ],
  "assert_mock": [
    {"contains": "Mock response from claude-haiku-4-5."}
  ]
}
```

Clear the screen, switch to a model, queue a canned response, say hello, read what's on screen, and verify the right things showed up. That's the entire test. You can see it in action here: https://youtu.be/nOynLkl0pOA

## The LLM Variability Problem

One thing that initially seemed tricky was testing LLM interactions. Ikigai is a chat application. Its output depends on whatever the model decides to say, which could be different every time. How do you write deterministic tests for non-deterministic responses?

Mock providers. We built a lightweight HTTP server in C that impersonates Anthropic, OpenAI, and Google. The test runner points Ikigai's API base URLs at localhost, so as far as Ikigai knows, it's talking to the real thing. Before each test, the runner queues up canned responses via a control endpoint. When Ikigai sends a chat request, the mock provider pops the next response off the queue and streams it back in the correct provider-specific SSE format. The test knows exactly what Ikigai will display because it controls what the "model" says.

But canned responses raise an obvious concern: what if the mocks don't match how the real APIs behave? The solution is layered verification. The same test scripts that run against mock providers can also be executed against actual providers, either by a human or (better) by an AI agent that can handle the slight variability in real LLM responses. Run the real-provider version once per release to validate the test design. Run the mock version continuously for fast, deterministic feedback.

Right now we have 13 e2e tests, one for each supported model across Anthropic, OpenAI, and Google. Each test switches to a model, sends "Hello," and verifies the response appears on screen. It's foundation work, proving the chat pipeline holds together end-to-end for each provider. Everything from here builds on top of it.

## Beyond Chat

Chat responses are just the starting point. The same approach works for memory leaks under Valgrind, performance benchmarks with defined thresholds, even verifying that the renderer produces the correct ANSI escape sequences. Anything you care about in software quality can be reduced to something you measure and assert.

Software is deterministic. Given the same input, it produces the same output. That means every behavior you care about can be pinned down with a test. If every requirement has one, and every test passes, the code is correct by definition. It doesn't matter whether it's elegant, idiomatic, or anything a human would have written.

## What's Left for the Human

My job now is writing user stories. For example:

> The user types `/model claude-opus-4-6/low` and the status bar shows the model name and reasoning level. The user sends a message and a response streams onto the screen. The user hits Ctrl-C and the application exits cleanly.

Claude turns those stories into e2e tests, then writes the code to make them pass. I never need to look at the implementation. I just need to be thorough about defining what "done" means.

We're not fully there yet. The 13 tests we have today are foundation work, proof that the runner, the mock providers, and the framebuffer assertions all hold together. Those tests stay and get built on until we have the full suite covering every feature, edge case, and failure mode. But the pipeline is real, the infrastructure works, and the principle holds: define it, test it, trust it.

Fifteen weeks in and I still haven't read the source code. I'm not sure I ever will.

*Co-authored by Mike Greenly and Claude Code*

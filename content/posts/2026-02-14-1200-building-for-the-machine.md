---
title: "Building for the Machine"
slug: "building-for-the-machine"
published: 2026-02-14
republished: []
last_build_hash: ""
last_build_lines: 0
---

Ikigai is a black box. It renders to the alternate terminal buffer, reads keystrokes one byte at a time, and produces nothing an external tool can see or touch. That's fine when a human is sitting at the keyboard. It's a dead end when the thing building the software is an LLM that can't see your screen.

## The Problem You Don't Notice Until You Do

We're wrapping up rel-11, which added internal tools: `fork`, `kill`, `send`, and `wait`, letting the LLM spawn and coordinate sub-agents inside a running Ikigai session. Tomorrow we're shifting gears. The next two weeks are dedicated to testability, and the socket is the centerpiece.

The motivation comes from twelve weeks of building Ikigai with Claude Code, where there's been an awkward gap in the workflow the entire time. Claude can read the source, modify it, compile it, run the tests. But it can't actually use the application it's building. Ikigai takes over the terminal. It swallows stdin. It paints directly to the screen through escape sequences. From Claude's perspective, launching Ikigai is like pushing a button and staring at a wall.

This doesn't bite you when you're fixing a parser or refactoring a data structure. The tests cover that. But for anything involving the REPL, the renderer, input handling, agent navigation, you end up being the eyes and hands. "Try pressing Ctrl+Right." "What do you see in the scrollback?" "Does the spinner look right?" Every one of those questions is Claude admitting it can't do its job without borrowing your senses.

There are workarounds. We've built a `IKIGAI_DEV` compile flag that dumps the framebuffer to disk before each `select()` call. Claude could take screenshots of the terminal. But framebuffer dumps are static snapshots you can read without interacting with, and screenshots are slow and expensive, burning vision tokens on every frame just to extract information that already exists as structured data inside the application. Neither one lets Claude actually drive the thing.

## A Socket for the Other Developer

We're adding a Unix domain socket to Ikigai. Not a debug port, not a testing harness. A control interface for our co-developer.

The socket carries a simple JSON protocol with two capabilities: keystroke injection and state inspection.

Keystroke injection feeds raw bytes into the same `ik_input_parse_byte()` function that processes terminal input. The bytes hit the same escape sequence parser, the same UTF-8 decoder, the same action dispatch. From the application's perspective, injected keystrokes are indistinguishable from someone typing at the keyboard. Claude can type "hello", press Enter, navigate to a child agent with Ctrl+Down, scroll through the response with Page Down, all programmatically.

State inspection returns JSON representations of what a human would see and know. The render buffer as a grid of cells. The scrollback content. The input line. Which agent is focused. What mode the application is in. Each inspectable type gets its own serializer that knows how to represent its contents meaningfully, not a raw memory dump but a structured view that makes sense to read.

## Why Not Just Write Better Tests?

Tests verify that code does what you intended. This socket lets Claude verify what actually happens when you use the application. Those are different things.

Ikigai's event loop multiplexes terminal input, LLM streaming responses, tool execution on worker threads, spinner animation, and agent navigation across a tree of forked conversations, all through a single `select()` call. The interactions between these systems are where the interesting bugs live. A keystroke arriving while a tool thread is completing. A resize event during streaming. Navigation to a dead agent. You can unit test the pieces, but the experience of using the application is an integration test that currently requires a human.

With the socket, Claude can make a code change, compile, launch Ikigai, inject a sequence of keystrokes, inspect the resulting state, and decide whether the change worked. The full loop, from edit to verification, without asking anyone to sit at a terminal.

## Two Weeks of Paying Down the Debt

The socket is part of a broader testability push. Twelve weeks of feature development at agentic pace has left us with solid unit test coverage but a gap at the integration level. The pieces work. We know less about whether the whole thing works, because verifying the whole thing has required a human at the keyboard.

Two weeks is a real investment, especially at the pace this project moves. But the math is simple: every hour Claude spends waiting for a human to manually test something is an hour the project isn't moving. The socket turns integration testing from a human bottleneck into something Claude can do autonomously, and that compounds over every feature that comes after.

Mechanically it's a small addition. A Unix socket, some JSON serialization, a new file descriptor in the `select()` set. The initial scope targets a terminal size around 100x40, which makes full-buffer dumps trivially small. No need for region queries or sparse representations yet.

## Software That Knows It Has Two Users

We've been learning this lesson in pieces throughout the project. Structured logging so Claude can read what happened. A dev-mode framebuffer dump so Claude can see what rendered. Now a socket so Claude can actually drive the application. Each one closed a gap where we were acting as a translator between Claude and the thing Claude was building.

The pattern is general. If an LLM is building your software, your software needs to be built for the LLM. Observable state, injectable input, structured inspection. The same courtesies you'd extend to any developer on the team, except this one can't look at your monitor. Your other developer doesn't have eyes and hands. Build accordingly.

---

*Co-authored by Mike Greenly and Claude Code*

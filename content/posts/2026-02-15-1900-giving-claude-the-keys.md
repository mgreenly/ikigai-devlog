---
title: "Giving Claude the Keys"
slug: "giving-claude-the-keys"
published: 2026-02-15
republished: []
last_build_hash: ""
last_build_lines: 0
---

Yesterday we wrote about [building for the machine](/posts/building-for-the-machine/), the idea that if an LLM is building your software, your software needs interfaces the LLM can use. Today we shipped the implementation: a Unix domain socket that lets Claude drive Ikigai like a human sitting at the keyboard.

## The Control Socket

The implementation is straightforward. Ikigai creates a Unix domain socket at startup in its runtime directory, adds it to the `select()` fd set alongside terminal input and everything else, and handles two message types: `read_framebuffer` and `send_keys`.

Keystroke injection feeds raw bytes into the same `ik_input_parse_byte()` function that processes terminal input. Same escape sequence parser, same UTF-8 decoder, same action dispatch. From Ikigai's perspective, injected keystrokes are indistinguishable from someone typing. A companion script called `ikigai-ctl` wraps the socket protocol so Claude can call `ikigai-ctl send_keys "hello\r"` or `ikigai-ctl read_framebuffer` from the command line.

Right now only the final composited framebuffer is available for inspection. We'll add others as we need them, likely the agent data structure, individual display stack layers, and the multi-line editor buffer.

## Divorcing the Pipeline from the Repo

The other half of today was pipeline work. In [Enter the Orchestrator](/posts/enter-the-orchestrator/) we called out the next step: divorcing the pipeline from the ikigai repo so it could work across projects. We've started on it. The pipeline skill and goal scripts now live in `ralph-pipeline`, a standalone repo that will eventually be a Claude Code plugin you install at the user level. It's not wired up as a plugin yet, but the code is out of the ikigai tree.

The goal is that the only thing a repo will need to work well with ralph is a good AGENTS.md file, nothing proprietary or ralph-specific, just the kind of project documentation that the Linux Foundation's AGENTS.md guidance already recommends. The repo describes itself (here's [Ikigai's AGENTS.md](https://github.com/mgreenly/ikigai/blob/main/AGENTS.md)), and the pipeline knows how to work with repos that describe themselves.

## Dependencies Need Merged, Not Done

Goal dependencies have been a background thought for a while, but today they came into sharp focus. We need the ability to say "don't start goal #92 until goal #90 is finished." And once you start thinking about what "finished" actually means, the answer isn't obvious. A goal is done when its PR merges, not when the PR is created.

The distinction matters because a PR might sit in review, get requested changes, or fail CI. If a dependent goal starts working against a branch that hasn't merged yet, it's building on sand.

We took the first concrete step: ralph-runs now records the PR number on the goal when it creates the pull request. That's the hook we'll need to monitor PR status. The next piece is watching for merge events and only unblocking dependent goals when the PR actually lands on main. Exactly what that monitoring looks like (GitHub webhooks, polling, or something else) is still an open question.

## The Dev Stream

The full day's work is on the livestream:

<iframe width="100%" height="400" src="https://www.youtube.com/embed/nGii97uy0AU" title="Ikigai Dev Stream - 02/15" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

## What This Changes

The control socket closes the last major gap in Claude's ability to work on Ikigai autonomously. Before today, Claude could read the source, modify it, compile it, and run the tests. It couldn't use the application. Now it can launch Ikigai, type into it, read what it renders, and decide whether a change worked. The full edit-compile-verify loop, no human required.

We haven't stress-tested it yet. The real proof will come over the next two weeks as we shift into the testability push described in [Building for the Machine](/posts/building-for-the-machine/). But the plumbing is in place, and the first manual tests worked exactly as expected.

---

*Co-authored by Mike Greenly and Claude Code*

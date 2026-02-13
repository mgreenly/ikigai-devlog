---
title: "The Shelf Life of Code"
slug: "the-shelf-life-of-code"
published: 2026-02-13
republished: []
last_build_hash: ""
last_build_lines: 0
---

When we started Ikigai twelve weeks ago, we chose C. The reasoning was straightforward: if you want a tool to land in Linux distributions, C is the path of least resistance. Package maintainers understand it, build systems support it natively, and there's no runtime to drag along. We were building software meant to be installed through `apt` and `dnf`, sitting alongside the rest of the system tools. That assumption turned out to be rooted in a world that's already disappearing.

## Software Used to Be Furniture

For decades, software was something you built, shipped, and maintained like a piece of furniture. You crafted it carefully, released it on a schedule, and expected it to sit in the same spot for months or years. Linux distribution packaging was designed for that world. A maintainer picks up your release tarball, patches it for their distribution, runs it through a build farm, and eventually it lands in a repository. The cycle takes weeks at best, months at worst. That's fine when your software changes quarterly.

We're not in that world anymore. LLMs and agents are turning software into something closer to a conversation than a product. Need a tool to migrate data between two formats? Ask for it. Need a monitoring dashboard for the next few weeks of a migration? Ask for it. If the tool keeps earning its place you mature it into something permanent. If you need something different next week you just ask for that instead. The cost of generating working software is collapsing toward zero, and that changes the basic economics. Pre-built, pre-packaged software stops being the default way you get things done. The default becomes asking for what you need right now.

That shift isn't just about throwaway scripts. In "[The Pivot](/posts/the-pivot/)," we talked about how the architecture underneath Ikigai shifted in a matter of days. Ralph has been churning through goals at a pace that would've been unimaginable a year ago. The code we wrote Monday might get restructured by Wednesday and replaced by Friday. Even the software we intend to keep behaves more like a living thing than a piece of furniture.

You can't package that for Debian.

## The Mismatch

The gap between agentic development velocity and traditional distribution timelines isn't a minor inconvenience. It's a fundamental incompatibility. Debian stable ships updates on a two-year cycle. Even rolling-release distributions measure their packaging lag in weeks. Meanwhile, tools like Claude Code ship through `curl | sh` and update themselves constantly, because they have to. The alternative is being obsolete before the package reviewer finishes reading your changelog.

This isn't just our experience. Across the industry, the tools that are actually keeping pace with agentic development all share the same delivery model: single binaries, direct downloads, self-updating. Go and Rust established this pattern years ago for DevOps tooling (Kubernetes, Terraform, Docker), and it's become the default for AI tooling too. The packaging philosophy that made sense when software changed slowly doesn't survive contact with software that changes daily.

## The Language Follows the Design

Once distro packaging stops being the goal, C loses its main advantage. The world has been moving toward memory-safe languages for good reason, and without the distro constraint there's no reason not to follow. The question is when. It turns out that starting in C gave us an unexpected advantage: the freedom to experiment without fighting the type system while the design was still taking shape. We didn't know what Ikigai's internals would look like. Agents that fork into hierarchies with delta-stored conversation history. A single-threaded REPL event loop multiplexing terminal input, LLM streaming, and tool execution across all those agents simultaneously. A replay system that walks ancestor chains to reconstruct state on restart. A layer cake renderer where each agent carries its own composable display stack. Tool execution on worker threads coordinated back to the main loop through mutexes. None of that was obvious twelve weeks ago.

Writing it in C first was how we figured out the memory ownership. Which contexts belong to agents, which belong to threads, which get stolen across boundaries when a tool completes. Talloc gave us hierarchical allocation that made the relationships visible. Now we understand how memory flows through all of these systems, and that understanding maps directly to Rust's ownership model. The lifetime annotations won't be guesses. They'll be documentation of patterns we already proved in C.

Somewhere down the road, Ikigai will move to Rust. Not for the delivery model (C is perfectly capable of producing a static binary with auto-update). The shift is about confidence. We know what the ownership graph looks like now, and Rust's borrow checker becomes an ally instead of an obstacle when you're encoding patterns you've already lived with.

We'll still have external dependencies. A database, probably some other key tools. But we'll treat them carefully, keeping the interfaces stable so that the many upgrades (and there will be many) don't break anything downstream.

## Same Root, Different Branch

This is really just another face of [the pivot](/posts/the-pivot/) we described yesterday. That post was about architecture: we thought we needed sophisticated agent hierarchies when dumb swarms with smart planners turned out to be the answer. This is about delivery: we thought we needed distro-friendly packaging when self-updating binaries turned out to be the only model that matches the pace.

Both mistakes came from the same place. We were building for a future that looked like a faster version of the past. But agentic development isn't faster traditional development. It's a different thing entirely. The assumptions you carry in from the old world don't just slow you down. They point you in the wrong direction.

---

*Co-authored by Mike Greenly and Claude Code*

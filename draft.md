---
title: "The Quality Harness"
slug: "quality-harness"
published: [TO BE FILLED]
republished: []
last_build_hash: ""
last_build_lines: 0
---

If you're going to let AI write your code, you need a way to know when it's wrong.

I started the ikigai project with a comprehensive test harness: formatting, linting, unit tests, integration tests, static analysis, dynamic analysis, and code coverage. Standard stuff. But almost immediately, I ran into a problem: the AI couldn't reliably understand the makefile output.

## Making Tests AI-Readable

My first attempt was simplifying the noise. I modified the Makefile to output just one line per file with a pass/fail emoji. Clean, minimal, easy to scan. It helped the AI run tests, but it couldn't figure out *why* things failed.

The breakthrough was wrapping everything in scripts with structured output.

Where I had `make check-unit` running unit tests in the Makefile, I created a corresponding `check-unit` script. Run with no parameters, it returns:
- `{"ok": true}` when everything passes
- `{"ok": false, "items": [ERROR-STRINGS]}` when something fails

Every script also takes a `--file=FILEPATH` flag that returns detailed errors about a specific file.

Suddenly, the AI could work with this reliably.

## The Fix Loop

The next evolution was the Ralph Loop and `fix-*` scripts. Instead of just checking, I created `fix-unit` that instructs the loop to run `check-unit`, then fix whatever issues it finds. This pattern works for any check.

Eventually, I added `fix-checks` - a meta-script that finds any failing `check-*` script and fixes the issues. Now the AI can clean up an entire codebase with a single command.

## The Philosophy

The point of all this is giving the AI a simple, predictable set of tools. When tools are predictable, development moves faster. You can hide specialized context - like how to parse gcov files or interpret sanitizer output - inside the scripts. The AI just needs to know: run the check, look at the JSON, act on the results.

Three principles emerged:

**If you can specify the process, write code to do it.** The scripts themselves are AI-written, because I could clearly describe what they should do.

**If you can specify the requirements, trust scripts to evaluate AI output.** Automated checks catch issues instantly, without human review.

**If you can't fully specify requirements, do human spot checks.** But minimize what requires human judgment.

When a new error type slips through, I don't just fix it. I work with the agent to improve the tests so they catch that class of error. Now it's caught in all future runs and never repeats.

## The Current Harness

Here's what runs on every change:

- `check-compile` - Does the code compile and link?
- `check-filesize` - Files must stay under 16KB so agents can load entire files without context issues
- `check-unit` - Run unit tests
- `check-integration` - Run integration tests
- `check-complexity` - ABC complexity and nesting depth limits
- `check-sanitize` - Static analysis with compiler sanitizers
- `check-tsan` - Thread safety and data race detection
- `check-valgrind` - Dynamic memory allocation issues
- `check-helgrind` - Dynamic thread problem detection
- `check-coverage` - Code coverage requirements

## What's Coming

I'm developing more checks: finding and pruning unused code, detecting code duplication for refactoring, enforcing project naming patterns. The tighter I make this gauntlet, the less likely errors slip through.

Each new check makes the AI more reliable. Each fix to the harness means one less class of bugs to worry about. The goal isn't perfection - it's a system where common mistakes get caught automatically, so human attention goes to problems that actually require judgment.

---

*Co-authored by Mike Greenly and Claude Code*

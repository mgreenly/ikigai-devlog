---
title: "Proving Code Is Dead"
slug: "proving-code-is-dead"
published: 2026-01-31
republished: []
last_build_hash: ""
last_build_lines: 0
---

Dead code removal is one of those problems that looks simple until you try to automate it.

I see people complaining about this online constantly. Their agents leave code behind. They have a hard time knowing when to remove something versus when to leave it alone. The agent gets conservative, afraid to delete anything, and cruft accumulates.

The fundamental difficulty is that you're proving a negative. You have to demonstrate that nothing, anywhere, needs this code. That's harder than showing something is used, which only requires finding one example.

We're making progress on this in ikigai. The solution isn't perfect, but it's working.

## The Test Coverage Trap

Here's what made our situation worse: we have 100% test coverage.

Sounds like a good thing, right? But think about what happens when an agent tries to remove a possibly dead function. It comments out the code, runs the tests, and... tests fail.

"The tests need this function," the agent concludes. "It must not be dead."

But wait. Why do the tests need it? Often the answer is: because a test was written specifically for that function. The test exists to cover the code. The code exists to be covered by the test. Neither serves any production purpose.

This is circular reasoning, and agents fall into it constantly.

## Two-Phase Detection

The first step is identifying candidates. We use `cflow` to trace what's reachable from `main()` and from each command handler. Then we use `ctags` to find all defined functions. The difference gives us orphans: functions that exist but aren't in any call path from production entry points.

But static analysis misses things. C code can call functions through pointers, vtables, and callbacks. A function with zero direct callers might still execute at runtime if its address is stored somewhere.

The key insight: for a function to be called via pointer, its name must appear somewhere in the source in a non-call context. You have to write `vtable->method = function_name` or `register_callback(function_name)` at some point. The function name appears without parentheses after it.

So we grep. If the function only appears in its own definition and in contexts with `(` immediately after, those are all calls. And if cflow says there are no calls from main, those must be test-only calls.

When both checks agree, the function is almost certainly dead.

## The Decision Tree

Once we have candidates, an agent evaluates each one through a structured decision process. This is where the real logic lives.

**Level 1 (Static Analysis):** Search for the function name in non-call contexts. If you find it assigned to a pointer or passed as a callback argument, stop. It's not dead.

**Level 2 (Build Test):** Comment out the function with `#if 0` and build the production binary. Not the tests. Just `make bin/ikigai`. If the build fails, something in production needs it directly. Not dead.

**Level 3 (Test Execution):** Run the full test suite with the function still commented out. This is where it gets interesting.

If all tests pass, the function is dead. Delete it.

If some tests fail, you have to think harder.

## Breaking the Circle

When a test fails, the naive response is "production code must need this function." But that's wrong. You have to ask: does this test directly reference the function?

If yes, the test was testing dead code. Delete the test.

If no, something else is going on. The test calls some production function, which calls our candidate function. But here's the critical question: is that intermediary function itself reachable from main?

Check cflow again. Trace back the call chain. If the intermediary is also unreachable from main, you've found a cluster of dead code. The test was written to exercise a production wrapper that only existed to call the dead function. Delete the function, delete the intermediary, delete the test. All of it is dead.

This is the insight that makes the system work. A failing test isn't evidence that code is live. It's evidence that something calls the function. That something might itself be dead. You have to verify the entire path back to main before concluding anything is actually used.

## The Goal Template

All of this logic lives in a goal template that gets passed to ralph when it runs the pruning task. The template lays out the decision tree explicitly, explains the circular dependency trap, and calibrates confidence.

The key instruction: when static analysis is clear, trust it. If cflow says unreachable and grep finds no pointer assignments, there is no mechanism by which C code can call this function. A failing test is not evidence to the contrary. It's a signal to investigate the test.

The template also tells ralph when to give up. If you find genuine evidence of pointer usage (a vtable entry, a callback registration), mark the function as a false positive and move on. But "a test fails and I don't understand why" isn't genuine doubt. That's a signal to dig deeper, not to abandon the analysis.

## Progress, Not Perfection

We're not done solving this problem. The system still has edge cases. Complex macro usage can hide function references. Generated code doesn't always get traced properly.

But the basic framework is sound. Detect candidates through static analysis. Verify through build and test. When tests fail, trace the call chain back to production entry points. Delete clusters of dead code together.

We've removed dozens of dead functions this way. The codebase gets cleaner, and we're learning how to make agents more aggressive about deletion without breaking things.

Dead code removal is proving a negative. The trick is being systematic about what "proof" actually means.

---

*Co-authored by Mike Greenly and Claude Code*

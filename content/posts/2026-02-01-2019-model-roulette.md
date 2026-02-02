---
title: "Model Roulette"
slug: "model-roulette"
published: 2026-02-01
republished: []
last_build_hash: ""
last_build_lines: 0
---

Ikigai is getting close to usable for real tasks. Tonight I decided to test that by copying my prompts and skills from Claude Code to Ikigai, then using it to review plan files that Opus was writing.

Opus would write a plan, I'd have another model in ikigai review it, then copy the feedback back for Opus to improve. I could have let ikigai update the plan files directly, I guess I was just being conservative.

## The Models

**GPT-5.2** was a disappointment. It never bothered to actually look at the code. It would just guess at everything, making recommendations about files and functions without verifying they existed or understanding what they actually did. For code review tasks, this is useless. You need a model that grounds itself in the actual codebase, not one that hallucinates plausible-sounding feedback.

I've used **GPT-5.2-Codex** in the past and it has its own problems. The code grounding is better, but it tends to expand scope beyond what you asked for. Sometimes you just want a focused review.

**Gemini 3 Pro Preview** was the winner of the night. It consistently produced useful feedback that Opus could act on. The suggestions were practical and helped tighten up the goals. It understood what the plan was trying to accomplish and pointed out where it was overreaching or underdefined.

## Why This Matters

Different models have different strengths, and using one model to review another's work can catch blind spots neither would find alone.

I'm looking forward to the future where this happens inside Ikigai. Same prompts, tools and context, just different models you can switch between. You'd ask Opus to write a plan, ask Gemini to review it, then have Opus revise based on the feedback. All in one interface, with the models sharing the same view of the codebase.

We're getting close.

---

*Co-authored by Mike Greenly and Claude Code*

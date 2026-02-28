---
title: "Ditching the Pull Request"
slug: "ditching-the-pull-request"
published: 2026-02-28
republished: []
last_build_hash: ""
last_build_lines: 0
---

We're ripping GitHub out of the Ralph pipeline tonight. PRs, webhooks, status polling, automerge, all of it goes. GitHub becomes a place we push to for safekeeping and nothing more.

This project has always been about questioning assumptions. In "[Disposable Clones](/posts/disposable-clones/)," we moved human review to after the merge, trusting tests over eyeballs. Tonight we're pulling on the next thread: if we don't need humans reviewing PRs, do we need PRs at all?

## The Complexity That Hid in Plain Sight

Back in "[Disposable Clones](/posts/disposable-clones/)," we described a workflow where agents clone, make changes, push a PR, and throw the clone away. Everything lived in GitHub, with PRs as the coordination layer and automerge handling the last mile. It worked.

Writing the PR tracking code for ralph-plans is where it fell apart. Every step that touches GitHub is a step that can fail. The network can drop, the API can timeout, webhooks can arrive late or not at all, and GitHub's own uptime has been spotty lately. We were taking a git merge that works reliably in milliseconds locally and routing it through all of that. The question went from "how do we handle these failure modes" to "why are we introducing them in the first place."

GitHub wasn't earning its place in the pipeline. It was just there because it's always been there.

## What Local Looks Like

The new architecture puts bare repos on local disk as the source of truth:

```
/mnt/store/git/<org>/<repo>          Bare repos (canonical)
    remote → github.com              Push-only backup

~/projects/<repo>                    Human working copies
    remote → /mnt/store/git/...      Clone from bare repo

~/.local/state/ralph/clones/...      Ralph working copies
    remote → /mnt/store/git/...      Clone from bare repo
```

Everything clones from the local bare repo. Ralph works in its clone, commits as it goes, and pushes the finished branch back to the bare repo. From there, `.ralph/check` runs the test gate. If it passes, the branch gets squash-merged onto main and main gets pushed to GitHub. The goal transitions to `done`.

No PR, no CI queue, no polling, no webhook. The merge is a local git operation.

## A Simpler State Machine

The old goal lifecycle had states that only existed to track what was happening on GitHub:

```
draft → queued → running → submitted → merged
                              ↓
                           rejected
```

`submitted` meant a PR was created. `merged` meant GitHub merged it. `rejected` meant the PR failed or was closed. Three states dedicated to watching something happen on someone else's infrastructure, and the state machine wasn't even complete yet. It didn't handle `stuck` goals at all. Trying to figure out how `stuck` would interact with open PRs is what actually killed the idea. The combinatorics of a stuck goal with a PR in some unknown state on GitHub was complexity with no upside.

The new lifecycle:

```
draft → queued → running → done
                    ↓
                  stuck → queued (retry)
```

`done` means the code passed the test gate and landed on main. `stuck` means it didn't. The pipeline no longer needs to understand GitHub's API or wonder whether a PR is mergeable.

## Multiple Agents, One Main

With GitHub out of the picture, we need to handle what PRs used to handle implicitly: multiple agents finishing work at different times against a moving main branch.

The approach is straightforward. Every ralph starts its work from main. As it works, it commits to a branch named after the goal number. When it finishes, it pushes the branch to the bare repo, tries to rebase onto current main (which may have moved if another ralph merged first), then runs `.ralph/check`. If both the rebase and the check pass, it squash-merges onto main and the goal is `done`.

If the rebase fails or the check fails, the goal moves to `stuck`. But the branch with the completed work still exists in the bare repo, so ralph can safely delete its local clone. Nothing is lost. When we go to resolve the stuck goal, whether in a manual session or with another goal, the starting point is that branch. The work is preserved, it just needs to be reconciled with whatever landed on main in the meantime.

Sequencing is handled through goal dependencies. If goal B depends on goal A, it won't leave the queue until A reaches `done`. This covers the common case where work needs to happen in order. For independent work, agents run in parallel and the rebase step handles convergence.

On startup, ralph-runs does housekeeping. If any clones are sitting on disk or any goals are stuck in `running`, it treats them as dirty. The clones get deleted and the goals move back to `queued` to start fresh. Whatever was on disk mid-run can't be trusted, so we don't try to recover it. Clean slate, every time.

## Why PRs Don't Apply Here

GitHub PRs are so deeply embedded in how we think about software development that questioning them feels like questioning version control itself. Code review, CI, and deployment all flow through PRs. The entire modern development workflow assumes them as the unit of integration.

But we don't do code review. We wrote about that in "[I've Never Read the Source Code](/posts/ive-never-read-the-source-code/)." We verify through tests and specifications, not by reading diffs. If you're not reviewing code on a PR, what is the PR actually doing? It's a merge button with extra steps.

CI is the other argument for PRs, and it's legitimate. But `.ralph/check` replaces it. Each repo defines its own test gate as an executable script. Exit 0 means pass. The gate runs locally, in the clone where the work happened, with full access to the test environment. No YAML, no queue behind other repos, no debugging why a GitHub Actions runner doesn't have the right version of something.

## The Ripple

This change touches every repo in the Ralph constellation. Ralph-plans loses its PR column, its GitHub polling, and three lifecycle states. Ralph-runs replaces `gh pr create` with a local squash-merge. Ralph-pipeline swaps `goal-submit` for `goal-done`. Ralph-shows and ralph-counts drop their PR-related displays and metrics. Target repos like Ikigai get a `.ralph/check` script.

It's a lot of code to remove, which is usually a sign you're headed in the right direction.

## What GitHub Becomes

GitHub isn't disappearing entirely. Every commit still gets pushed there as a backup. If the local machine gets hit by a toilet seat falling from space, the code is safe. And eventually we'll accept PRs from GitHub as an input channel, a convenient way for someone (or some other system) to hand us a branch. But that branch gets pulled into the local workflow and handled the same way as everything else. GitHub becomes an on-ramp, not the road itself.

We keep rediscovering this pattern in agentic development: the tools and platforms that feel essential often just feel that way because we've never tried without them. GitHub didn't earn its place in the pipeline through technical necessity. It inherited the spot because that's how software development works, until you realize it doesn't have to.

---

*Co-authored by Mike Greenly and Claude Code*

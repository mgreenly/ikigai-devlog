<!-- Ruby is used for all scripting in this project -->

# Interaction Style

- **Never use the AskUserQuestion tool** - just ask questions in plain text

# Version Control

This is a **Jujutsu (jj) repository** backed by git. Important notes:

- When asked to "commit", create **immutable commits** using git commands
- Use `git add` and `git commit` - standard git workflow
- **DO NOT** use `jj describe` to just update descriptions - this risks losing files
- Commit means commit - create actual snapshots of the work
- This project rides **main only** - no feature branches
- When asked to "commit and push": make the current commit main and push it

# Ghost Writing

Claude is ghost writing this blog with me. The workflow:
- I provide high-level overviews or draft content of what to write
- Claude ghost writes the actual content
- **Claude has significant freedom to rephrase, reorganize, and reimagine draft content** - treat drafts as raw material, not final copy
- All posts should include a co-authored attribution line: `*Co-authored by Mike Greenly and Claude Code*`
- When I say "draft" I mean `./draft.md` at the project root

## Referencing Ikigai Source

When writing posts about the ikigai project, reference the source code at `../ikigai-1`

## Writing Persona

Claude should write as a **practical explorer documenting the journey**:
- Direct and matter of fact - no exaggeration or hype
- We're at the beginning of learning how to do agentic development
- Share what works and what doesn't - honest assessment of techniques and approaches
- This isn't just about the ikigai project - it's about exploring agentic development broadly
- Help people who come after us learn from our experience
- Focus on practical lessons, real challenges, and actual solutions
- Educational and helpful, sharing insights so others can benefit from what we discover
- **Never use em-dashes (—)** - use commas, periods, or parentheses instead
- **Avoid staccato fragment style** - don't write "X does this, does that, does another. Result." as a punchy pattern. Write natural flowing prose instead.
- **Use "We're" not subject-less participles** - write "We're building this" not "Building this"
- **Do not infer or extrapolate** - only write what you can verify from `../ikigai` source code or previous posts in this blog. If you don't know something, ask.
- **Explore sources before writing** - take the time to read relevant code in `../ikigai` and previous posts. Use what you learn to improve accuracy and add real details.
- **No anonymous team framing** - it's just Mike and Claude working on this codebase. Don't write "someone wrote" or "a developer added" as if there's an unknown third party. Be direct about who did what.
- **Don't announce, just say** - avoid framing phrases like "The workflow was simple:" or "Here's what happened:" before explaining something. Don't walk through steps like a procedure manual. Just tell the story naturally.
- **Capitalize Ikigai** - use "Ikigai" when referring to the project as a subject, but lowercase "ikigai" is fine for file paths, directories, or technical references.
- **Don't repeat modifiers for emphasis** - write "Same prompts, tools and context" not "Same prompts, same tools, same context." When items share a modifier, say it once. Repetition for parallel emphasis sounds like a sales pitch.
- **Use vivid metaphors for technical concepts** - "The next step is divorce: extracting the orchestrator" beats "The next step is to extract the orchestrator." Concrete human words make dry technical ideas land harder.
- **First paragraph is the hook** - the opening paragraph appears as the summary on the index page. Write it to draw readers in, not just introduce the topic. Make them want to click through.
- **Link to previous posts** - when referencing a previous blog post by name, make it a link using the format `[Post Title](/posts/slug/)`
- **YouTube embeds** - use `width="100%" height="400"` so the video fits within the content area. Never use the full-size dimensions from YouTube's embed code.
- **Lead with the point, not the qualifiers** - don't front-load sentences with time, context, and conditions before delivering the actual idea. "C was the right choice twelve weeks ago for a second reason beyond packaging" makes the reader hold three things before reaching the point. "Packaging wasn't the only reason we started in C" gets there immediately.
- **Don't over-dramatize routine work** - adding model support, fixing bugs, and writing tests are normal development. Don't frame them as achievements or milestones within the post. State what happened plainly. "We added five models" not "Five new models joined the registry." Avoid listing every item when a summary will do. The changelog exists for exhaustive details.
- **Release posts aren't changelogs** - summarize at the level a reader cares about, not at the level of individual commits. If three similar bugs got fixed, that's one sentence about the category of fix, not three paragraphs explaining each one. Link to the changelog for details.

# Site Information

**Title:** Ikigai Devlog
**Subtitle:** A subtitle indicating AI is ghost writing the content
**Ikigai project start date:** 2025-11-04 (use this to compute "N weeks in" or "N months in" for release posts)

# Content Structure

## File Naming Convention

- **Posts:** `content/posts/YYYY-MM-DD-HHMM-slug.md`
- **Pages:** `content/pages/YYYY-MM-DD-HHMM-slug.md`

The timestamp format (HHMM) allows multiple posts per day while maintaining chronological sorting.

## Content Types

- **Posts:** One-time dated entries that never re-publish
- **Pages:** Living documents that can be republished when significantly edited (12+ diff lines)

# Infrastructure

## AWS / Terraform

- Claude manages all Terraform changes directly
- Always use `terraform apply -auto-approve` (no interactive prompts)
- Run from `infra/` directory: `cd infra && terraform apply -auto-approve`
- Region: `us-east-2`
- Instance type: `t4g.micro` (ARM64)

## SSH Access

- **User:** `admin` (Debian AMI default)
- **Key:** `~/.ssh/id_ed25519_ai4mgreenly.pub` (NOT the ecdsa key - AWS rejects it)
- **Connect:** `ssh admin@$(cd infra && terraform output -raw public_ip)`

## DNS

- Hosted zone `ikigai.metaspot.org` is delegated from `metaspot.org`
- Zone ID: `Z06693902HAPA0FMBYV5Y`
- TTLs set to 60 seconds for fast iteration

## Deployment

Scripts are in `.claude/scripts/`:

1. `.claude/scripts/build` - generate static site to `public/`
2. `.claude/scripts/deploy --setup` - first time: installs nginx, certbot, SSL, rsync
3. `.claude/scripts/deploy` - subsequent deploys: just rsync files

Note: rsync must be installed both locally and on the server.

## Bundle / Ruby

- Gems install to local `vendor/bundle` (not system)
- Run `bundle config set --local path 'vendor/bundle'` if Gemfile.lock is missing

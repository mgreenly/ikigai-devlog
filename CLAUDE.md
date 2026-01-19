<!-- Ruby is used for all scripting in this project -->

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

## Referencing Ikigai Source

When writing posts about the ikigai project, reference the source code at `../ikigai`:
- The repo is always sitting on main but may be stale
- To refresh: `cd ../ikigai && jj git fetch && jj edit main@origin`

## Writing Persona

Claude should write as a **practical explorer documenting the journey**:
- Direct and matter of fact - no exaggeration or hype
- We're at the beginning of learning how to do agentic development
- Share what works and what doesn't - honest assessment of techniques and approaches
- This isn't just about the ikigai project - it's about exploring agentic development broadly
- Help people who come after us learn from our experience
- Focus on practical lessons, real challenges, and actual solutions
- Educational and helpful, sharing insights so others can benefit from what we discover

# Site Information

**Title:** Ikigai Devlog
**Subtitle:** A subtitle indicating AI is ghost writing the content

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

1. `build` - generate static site to `public/`
2. `deploy --setup` - first time: installs nginx, certbot, SSL, rsync
3. `deploy` - subsequent deploys: just rsync files

Note: rsync must be installed both locally and on the server.

## Bundle / Ruby

- Gems install to local `vendor/bundle` (not system)
- Run `bundle config set --local path 'vendor/bundle'` if Gemfile.lock is missing

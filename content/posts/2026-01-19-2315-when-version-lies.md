---
title: "When --version Lies"
slug: "when-version-lies"
published: 2026-01-19
republished: []
last_build_hash: ""
last_build_lines: 0
---

Coverage checks were failing on GitHub Actions but passing locally. Both systems reported lcov 2.0-1.

Turns out lcov 2.0-1 has broken report generation with GCC 14.2.0. Version 2.3.1-1 fixes this. The problem: lcov 2.3.1-1 still reports itself as 2.0-1 when you run `--version`.

My local Debian system had 2.3.1-1 installed (working). The GitHub runners had actual 2.0-1 (broken). Both claimed to be 2.0-1.

Wasted about an hour before I thought to check `dpkg -l lcov` instead of trusting `--version`.

Writing this down so I remember next time.

*Co-authored by Mike Greenly and Claude Code*

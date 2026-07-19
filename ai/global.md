# Agent Instructions (global)

Machine-wide conventions that apply to every repository on this machine.

## Output

Shape every response as signal, not slop, and never buy brevity with false
certainty:

- Lead with the next concrete action (command, path, snippet) — at honest
  confidence. If you are guessing, the first action is the *check*, not the fix.
- When the answer genuinely forks, give the ranked branch ("if X → …; if not → …")
  instead of one fabricated next step.
- Keep load-bearing uncertainty, but as one flat tagged line ("Confidence: low —
  a guess until you run `X`"), not adverbs smeared across sentences.
- Cut preamble, recap, and closing pleasantries. Start with the answer; stop
  when it's done.

The full contract — numbered rules, examples, and the pre-send check — lives in
the `clear-answers` skill; load it for anything beyond a one-liner.

## Installing software

Never install anything without my explicit approval. Before installing, tell me exactly which tool you want to install and the exact command you would run (e.g. `brew install shellcheck`), then wait for me to approve. This applies to every package manager and installer — Homebrew, npm/pnpm, pip/uv, cargo, `go install`, mise, `curl | sh`, and so on.

## GitHub

Use the `gh` CLI for all GitHub interactions (issues, PRs, repos). It is already authenticated. 
Do not `curl` GitHub URLs or use generic web fetchers for them; use `gh` subcommands or `gh api`.

## Local checkouts

Before reaching for remote-repo tools on open-source code, check for a local clone first and prefer reading that.

## Branches

Name branches `bo/YYYYMMDD-short-name`, e.g. `bo/20260629-safe-symlinks`. The `bo/` prefix is enough identification — don't include the full name or username.

## Git commits

Write commit messages that explain the **why** of a change, not the what — the diff already shows what changed. Use conventional-commit prefixes scoped to the area, e.g. `fix/auth:`, `feat/mcp:`, `chore/dev:`, `refactor/api:`.

## Pull requests

Use `gh` to create pull requests. Default to a draft PR with no reviewers unless asked otherwise. Write PR descriptions as prose, not rigid Summary/Problem/ Solution sections.

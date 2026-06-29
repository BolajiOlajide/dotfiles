# Agent Instructions (global)

Machine-wide conventions that apply to every repository on this machine.

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

# Skills

Shared [Agent Skills](https://code.claude.com/docs/en/skills) for every coding
agent. Each skill is one subdirectory containing a `SKILL.md` (with `name` +
`description` frontmatter) and any optional `references/`, `scripts/`, or
`assets/`.

`scripts/sync.sh` symlinks each skill subdirectory into every provider's skills
directory, so there's a single source of truth here:

| Provider | Skills directory |
|----------|------------------|
| Claude Code | `~/.claude/skills/<name>` |
| Codex | `~/.codex/skills/<name>` |
| Amp | `~/.config/agents/skills/<name>` |
| Conductor | *(inherits — it runs Claude/Codex, which see the links above)* |

## Adding a skill

Run it interactively — it prompts for the name, description, then the
instructions (type the body and press Ctrl-D when done):

```bash
make skill
```

Or pass everything up front:

```bash
make skill name=my-skill desc="Use when ..."
# or, directly, with an option to open it in $EDITOR afterwards:
./ai/new-skill.sh --edit my-skill "Use when ..."
```

Either way it creates `ai/skills/my-skill/SKILL.md` with the frontmatter filled in
and runs `scripts/sync.sh` to symlink it into every provider.

To do it by hand instead: create `ai/skills/<name>/SKILL.md` with `name` +
`description` frontmatter and run `make sync`.

To remove a skill, delete its `ai/skills/<name>/` directory and re-run `make sync`
— sync prunes the now-dangling `<provider>/skills/<name>` symlinks automatically.

This `README.md` is not a skill (no `SKILL.md`), so `scripts/sync.sh` skips it.

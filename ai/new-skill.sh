#!/usr/bin/env bash

# Scaffold a new agent skill under ai/skills/<name>/SKILL.md and symlink it into
# every provider (via sync.sh).
#
# Interactive (no name given) — prompts for name, description, then instructions:
#   ./new-skill.sh
#
# Non-interactive:
#   ./new-skill.sh <name> [description]
#   ./new-skill.sh --edit <name> [description]   # open SKILL.md in $EDITOR after
#
# <name> must be kebab-case (lowercase letters, digits, hyphens).

set -euo pipefail

# This script lives in ai/; operate from the repo root so ./scripts/sync.sh and
# the ai/skills paths resolve.
cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.."

NAME_RE='^[a-z0-9]+(-[a-z0-9]+)*$'

edit=0
if [[ "${1:-}" == "-e" || "${1:-}" == "--edit" ]]; then
    edit=1
    shift
fi

name="${1:-}"
shift || true
description="${*:-}"
body=""

# Title-case the name for the heading: my-skill -> My Skill
titlecase() {
    echo "$1" | tr '-' ' ' | awk '{ for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2) } 1'
}

if [[ -z "$name" ]]; then
    # Interactive mode: prompt on stdin (the terminal, under `make skill`).
    while true; do
        if ! read -rp "Skill name (kebab-case): " name; then
            echo; echo "Aborted." >&2; exit 1
        fi
        if [[ -z "$name" ]]; then
            echo "  name is required."
        elif [[ ! "$name" =~ $NAME_RE ]]; then
            echo "  must be kebab-case, e.g. my-skill."
        elif [[ -e "ai/skills/$name" ]]; then
            echo "  ai/skills/$name already exists."
        else
            break
        fi
    done

    read -rp "Description (when should the agent use this?): " description || true

    echo "Instructions — type the skill body, then press Ctrl-D on a blank line:"
    body=$(cat)
else
    # Non-interactive validation.
    if [[ ! "$name" =~ $NAME_RE ]]; then
        echo "Error: name must be kebab-case (e.g. my-skill), got: $name" >&2
        exit 2
    fi
    if [[ -e "ai/skills/$name" ]]; then
        echo "Error: ai/skills/$name already exists" >&2
        exit 1
    fi
fi

description="${description:-Use when ...}"
[[ -n "$body" ]] || body="<!-- Replace this with instructions for the agent. -->"

dir="ai/skills/$name"
file="$dir/SKILL.md"

# YAML-escape the description for a double-quoted scalar so values containing
# `:`, `#`, quotes, etc. don't produce invalid frontmatter.
esc_description=${description//\\/\\\\}
esc_description=${esc_description//\"/\\\"}

mkdir -p "$dir"
cat > "$file" <<EOF
---
name: $name
description: "$esc_description"
---

# $(titlecase "$name")

$body
EOF

echo "Created $file"

# Symlink it into every provider. Keep sync.sh output visible so any
# "Backed up ..." messages (real files being moved aside) aren't hidden.
echo "Running sync.sh..."
./scripts/sync.sh
echo "Linked into Claude, Codex, and Amp via sync.sh"

if [[ "$edit" == 1 ]]; then
    "${EDITOR:-vi}" "$file"
fi

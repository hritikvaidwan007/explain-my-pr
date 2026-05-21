#!/usr/bin/env bash
# Copy the skill into user-level directories (no plugin marketplace required).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_SRC="$ROOT/skills/explain-my-pr"
NAME="explain-my-pr"

install_one() {
  local dest="$1"
  mkdir -p "$dest"
  cp "$SKILL_SRC/SKILL.md" "$SKILL_SRC/reference.md" "$dest/"
  rm -rf "$dest/examples"
  cp -r "$SKILL_SRC/examples" "$dest/"
  echo "Installed → $dest"
}

install_one "${HOME}/.cursor/skills/${NAME}"
install_one "${HOME}/.claude/skills/${NAME}"
install_one "${HOME}/.agents/skills/${NAME}"

echo "Done. Ask your agent to follow the ${NAME} skill."

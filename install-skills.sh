#!/usr/bin/env bash
# Install agent skills from https://github.com/EnderPuentes/ai-agent-skills
# Usage: ./install-skills.sh [--update]

set -euo pipefail

SKILLS_REPO="${SKILLS_REPO:-https://github.com/EnderPuentes/ai-agent-skills.git}"
SKILLS_DIR="${SKILLS_DIR:-$HOME/.local/share/ai-agent-skills}"
AGENTS_SKILLS="$HOME/.agents/skills"
PI_SKILLS="$HOME/.pi/agent/skills"

info()  { echo "→ $*"; }
ok()    { echo "✓ $*"; }
warn()  { echo "⚠ $*" >&2; }

clone_or_update_repo() {
  if [[ -d "$SKILLS_DIR/.git" ]]; then
    info "Updating ai-agent-skills…"
    git -C "$SKILLS_DIR" pull --ff-only
  else
    info "Cloning ai-agent-skills…"
    mkdir -p "$(dirname "$SKILLS_DIR")"
    git clone --depth=1 "$SKILLS_REPO" "$SKILLS_DIR"
  fi
  ok "Skills repo ready at $SKILLS_DIR"
}

prepare_skills_dirs() {
  # Replace directory-wide symlinks (legacy dotfiles layout) with per-skill links
  for dir in "$AGENTS_SKILLS" "$PI_SKILLS"; do
    if [[ -L "$dir" ]]; then
      warn "Removing legacy symlink: $dir"
      rm "$dir"
    fi
    mkdir -p "$dir"
  done
}

link_skills() {
  local count=0

  for skill_dir in "$SKILLS_DIR"/*/; do
    [[ -f "${skill_dir}SKILL.md" ]] || continue

    local skill_name
    skill_name="$(basename "$skill_dir")"

    ln -sfn "$skill_dir" "$AGENTS_SKILLS/$skill_name"
    ln -sfn "$skill_dir" "$PI_SKILLS/$skill_name"
    count=$((count + 1))
  done

  ok "Linked $count skills to $AGENTS_SKILLS and $PI_SKILLS"
}

main() {
  echo ""
  echo "Installing skills from EnderPuentes/ai-agent-skills"
  echo ""

  clone_or_update_repo
  prepare_skills_dirs
  link_skills

  echo ""
  ok "Skills installation complete!"
  echo ""
  echo "Install a single skill with npx (see ai-agent-skills README):"
  echo "  npx skills add $SKILLS_REPO --skill typescript"
  echo ""
  echo "Update all skills:"
  echo "  $0 --update"
  echo ""
}

main "$@"

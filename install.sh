#!/usr/bin/env bash
# Bootstrap development environment from zero.
# Usage: curl -fsSL <raw-url>/install.sh | bash
#    or: ./install.sh

set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
export DOTFILES
LOG="${DOTFILES}/.install-log"

# ── Helpers ──────────────────────────────────────────────────────────────────

info()  { echo "→ $*"; }
ok()    { echo "✓ $*"; }
warn()  { echo "⚠ $*" >&2; }
die()   { echo "✗ $*" >&2; exit 1; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

link_file() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    warn "$dest exists and is not a symlink — backing up to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -sfn "$src" "$dest"
}

link_dir() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -d "$dest" && ! -L "$dest" ]]; then
    warn "$dest exists and is not a symlink — backing up to ${dest}.bak"
    mv "$dest" "${dest}.bak"
  fi
  ln -sfn "$src" "$dest"
}

# ── 1. System packages (Debian/Ubuntu) ───────────────────────────────────────

install_system_packages() {
  if ! has_cmd apt-get; then
    warn "apt-get not found — skipping system package install"
    return
  fi

  info "Installing system packages…"
  sudo apt-get update -qq
  local packages=(
    git curl wget zsh neovim bat lazygit unzip fontconfig
    fonts-jetbrains-mono
    build-essential ripgrep fd-find
    ca-certificates gnupg
  )
  sudo apt-get install -y -qq "${packages[@]}" 2>/dev/null || {
    warn "lazygit not in apt — retrying without it"
    sudo apt-get install -y -qq \
      git curl wget zsh neovim bat \
      build-essential ripgrep fd-find \
      ca-certificates gnupg
    warn "Install lazygit manually: https://github.com/jesseduffield/lazygit#installation"
  }

  # fd-find on Debian/Ubuntu is installed as fdfind
  if has_cmd fdfind && ! has_cmd fd; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd 2>/dev/null || true
  fi

  ok "System packages installed"
}

# ── 1b. JetBrains Mono Nerd Font ─────────────────────────────────────────────

install_jetbrains_font() {
  if command -v fc-list >/dev/null 2>&1 && fc-list | grep -qi "JetBrainsMono Nerd Font"; then
    ok "JetBrains Mono Nerd Font already installed"
    return
  fi

  local font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
  info "Installing JetBrains Mono Nerd Font…"
  mkdir -p "$font_dir"

  local version="v3.2.1"
  local zip_url="https://github.com/ryanoasis/nerd-fonts/releases/download/${version}/JetBrainsMono.zip"
  local tmp_zip
  tmp_zip="$(mktemp /tmp/JetBrainsMono.XXXXXX.zip)"

  if curl -fsSL "$zip_url" -o "$tmp_zip" && unzip -qo "$tmp_zip" "JetBrainsMonoNerdFont-*.ttf" -d "$font_dir"; then
    rm -f "$tmp_zip"
    fc-cache -f "$HOME/.local/share/fonts" 2>/dev/null || true
    ok "JetBrains Mono Nerd Font installed to $font_dir"
  else
    rm -f "$tmp_zip"
    warn "Could not install Nerd Font automatically"
    warn "Install manually: https://www.nerdfonts.com/font-downloads"
    warn "Or: sudo apt install fonts-jetbrains-mono"
  fi
}

# ── 2. Oh My Zsh ─────────────────────────────────────────────────────────────

install_oh_my_zsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "Oh My Zsh already installed"
    return
  fi

  info "Installing Oh My Zsh…"
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "Oh My Zsh installed"
}

# ── 3. Zsh plugins ───────────────────────────────────────────────────────────

install_zsh_plugins() {
  local plugins_dir="$HOME/.zsh"
  mkdir -p "$plugins_dir"

  clone_plugin() {
    local name="$1" repo="$2"
    local dest="$plugins_dir/$name"
    if [[ -d "$dest" ]]; then
      ok "zsh plugin $name already present"
    else
      info "Cloning zsh plugin $name…"
      git clone --depth=1 "$repo" "$dest"
      ok "zsh plugin $name installed"
    fi
  }

  clone_plugin zsh-autosuggestions \
    https://github.com/zsh-users/zsh-autosuggestions
  clone_plugin zsh-syntax-highlighting \
    https://github.com/zsh-users/zsh-syntax-highlighting
  clone_plugin zsh-completions \
    https://github.com/zsh-users/zsh-completions
}

# ── 4. NVM + Node.js ─────────────────────────────────────────────────────────

install_nvm() {
  if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    ok "nvm already installed"
  else
    info "Installing nvm…"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    ok "nvm installed"
  fi

  # shellcheck source=/dev/null
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  if ! has_cmd node; then
    info "Installing Node.js LTS…"
    nvm install --lts
    nvm use --lts
  fi
  ok "Node.js $(node --version)"
}

# ── 5. Pi coding agent ───────────────────────────────────────────────────────

install_pi() {
  # shellcheck source=/dev/null
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  if has_cmd pi; then
    ok "Pi already installed ($(pi --version 2>/dev/null || echo 'unknown version'))"
  else
    info "Installing Pi coding agent…"
    npm install -g --ignore-scripts @earendil-works/pi-coding-agent
    ok "Pi installed"
  fi
}

# ── 6. Symlink configs ───────────────────────────────────────────────────────

link_configs() {
  info "Linking dotfiles…"

  # Zsh
  link_file "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

  # Neovim
  link_dir "$DOTFILES/nvim" "$HOME/.config/nvim"

  # Pi config
  mkdir -p "$HOME/.pi/agent/npm"
  link_file "$DOTFILES/pi/agent/settings.json" "$HOME/.pi/agent/settings.json"
  link_file "$DOTFILES/pi/web-search.json" "$HOME/.pi/web-search.json"
  link_file "$DOTFILES/pi/agent/npm/package.json" "$HOME/.pi/agent/npm/package.json"
  link_file "$DOTFILES/pi/agent/npm/.gitignore" "$HOME/.pi/agent/npm/.gitignore"

  ok "Dotfiles linked"
}

# ── 7. Pi npm dependencies ───────────────────────────────────────────────────

install_pi_packages() {
  # shellcheck source=/dev/null
  export NVM_DIR="$HOME/.nvm"
  # shellcheck source=/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  if [[ -f "$HOME/.pi/agent/npm/package.json" ]]; then
    info "Installing Pi npm packages…"
    npm install --prefix "$HOME/.pi/agent/npm" --silent
    ok "Pi npm packages installed"
  fi
}

# ── 8. Pi credentials template ─────────────────────────────────────────────

setup_pi_auth() {
  local auth="$HOME/.pi/agent/auth.json"
  if [[ -f "$auth" ]]; then
    ok "Pi auth.json already exists (not overwritten)"
    return
  fi

  if [[ -f "$DOTFILES/pi/auth.json.example" ]]; then
    cp "$DOTFILES/pi/auth.json.example" "$auth"
    chmod 600 "$auth"
    warn "Created $auth from template — add your API key before running pi"
  fi
}

# ── 9. Default shell ─────────────────────────────────────────────────────────

set_default_shell() {
  if [[ "${SHELL:-}" == *zsh* ]]; then
    ok "zsh is already the default shell"
    return
  fi

  if has_cmd zsh; then
    info "Setting zsh as default shell (may prompt for password)…"
    chsh -s "$(command -v zsh)" "$USER" 2>/dev/null || \
      warn "Could not change default shell — run: chsh -s $(command -v zsh)"
  fi
}

# ── 10. Agent skills (last step) ─────────────────────────────────────────────

install_agent_skills() {
  local skills_repo="${SKILLS_REPO:-https://github.com/EnderPuentes/ai-agent-skills.git}"
  local skills_dir="${SKILLS_DIR:-$HOME/.local/share/ai-agent-skills}"
  local agents_skills="$HOME/.agents/skills"
  local pi_skills="$HOME/.pi/agent/skills"
  local count=0

  info "Installing agent skills from ai-agent-skills…"

  if [[ -d "$skills_dir/.git" ]]; then
    info "Updating ai-agent-skills…"
    git -C "$skills_dir" pull --ff-only
  else
    info "Cloning ai-agent-skills…"
    mkdir -p "$(dirname "$skills_dir")"
    git clone --depth=1 "$skills_repo" "$skills_dir"
  fi

  for dir in "$agents_skills" "$pi_skills"; do
    if [[ -L "$dir" ]]; then
      warn "Removing legacy symlink: $dir"
      rm "$dir"
    fi
    mkdir -p "$dir"
  done

  for skill_dir in "$skills_dir"/*/; do
    [[ -f "${skill_dir}SKILL.md" ]] || continue

    local skill_name
    skill_name="$(basename "$skill_dir")"

    ln -sfn "$skill_dir" "$agents_skills/$skill_name"
    ln -sfn "$skill_dir" "$pi_skills/$skill_name"
    count=$((count + 1))
  done

  ok "Linked $count skills to $agents_skills and $pi_skills"
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
  echo ""
  echo "╔══════════════════════════════════════════╗"
  echo "║   Ender Puentes — dotfiles installer     ║"
  echo "╚══════════════════════════════════════════╝"
  echo ""
  echo "DOTFILES=$DOTFILES"
  echo ""

  {
    install_system_packages
    install_jetbrains_font
    install_oh_my_zsh
    install_zsh_plugins
    install_nvm
    install_pi
    link_configs
    install_pi_packages
    setup_pi_auth
    set_default_shell
    install_agent_skills
  } 2>&1 | tee "$LOG"

  echo ""
  echo "════════════════════════════════════════════"
  ok "Installation complete!"
  echo ""
  echo "Next steps:"
  echo "  1. Edit ~/.pi/agent/auth.json with your API key"
  echo "  2. Restart your terminal (or: exec zsh)"
  echo "  3. Run: pi          — start Pi coding agent"
  echo "  4. Run: nvim        — Neovim (plugins install on first launch)"
  echo ""
  echo "Quick install on a new machine:"
  echo "  git clone https://github.com/EnderPuentes/dotfiles.git ~/.dotfiles"
  echo "  ~/.dotfiles/install.sh"
  echo ""
}

main "$@"

# dotfiles

Personal development environment by [Ender Puentes](https://github.com/EnderPuentes).

A public, batteries-included setup for **Zsh**, **Neovim**, **Pi coding agent**, and **agent skills** — installable from zero with a single script.

## What's included

| Component | Path | Description |
|-----------|------|-------------|
| **Zsh** | `zsh/.zshrc` | Oh My Zsh + plugins + nvm |
| **Neovim** | `nvim/` | Lazy.nvim, LSP, Telescope, Treesitter |
| **Pi agent** | `pi/` | Cursor SDK, context-mode, web access |
| **Skills** | `install-skills.sh` | Installs from [ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills) |

### Pi packages

- [pi-cursor-sdk](https://www.npmjs.com/package/pi-cursor-sdk) — Cursor provider
- [context-mode](https://www.npmjs.com/package/context-mode) — Context optimization
- [pi-web-access](https://www.npmjs.com/package/pi-web-access) — Web search & fetch
- [pi-screenshots-picker](https://www.npmjs.com/package/pi-screenshots-picker) — Screenshot tools

Skills from npm packages (context-mode, librarian) install automatically with Pi packages.

### Agent skills

Skills live in a separate repository: **[ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills)**.

Install all default skills:

```bash
~/.dotfiles/install-skills.sh
```

Install a single skill with [skills.sh](https://skills.sh):

```bash
npx skills add https://github.com/EnderPuentes/ai-agent-skills --skill typescript
```

Available skills include `typescript`, `zod`, `jsdoc`, `conventional-commits`, `code-review`, `grill-me`, `tailwind-css`, `shadcn-ui`, and more — see the [ai-agent-skills README](https://github.com/EnderPuentes/ai-agent-skills#installation).

## Quick install

### One-liner (clone + install)

```bash
git clone https://github.com/EnderPuentes/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

### From zero on Debian/Ubuntu

The installer handles everything:

1. System packages (`git`, `zsh`, `neovim`, `bat`, `ripgrep`, `fd`)
2. [Oh My Zsh](https://ohmyz.sh/)
3. Zsh plugins (autosuggestions, syntax-highlighting, completions)
4. [nvm](https://github.com/nvm-sh/nvm) + Node.js LTS
5. [Pi coding agent](https://pi.dev)
6. Symlinks for all configs
7. Pi npm package dependencies
8. `auth.json` template (you add your API key)
9. Agent skills from [ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills) (last step)

### After install

```bash
# 1. Add your API key
nano ~/.pi/agent/auth.json

# 2. Restart shell
exec zsh

# 3. Start coding
pi        # Pi coding agent
nvim      # Neovim (plugins install on first launch)
```

## Manual install

If you prefer step-by-step control:

```bash
git clone https://github.com/EnderPuentes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Link configs
ln -sfn ~/.dotfiles/zsh/.zshrc ~/.zshrc
ln -sfn ~/.dotfiles/nvim ~/.config/nvim

# Pi config
mkdir -p ~/.pi/agent/npm
ln -sfn ~/.dotfiles/pi/agent/settings.json ~/.pi/agent/settings.json
ln -sfn ~/.dotfiles/pi/web-search.json ~/.pi/web-search.json
ln -sfn ~/.dotfiles/pi/agent/npm/package.json ~/.pi/agent/npm/package.json

# Pi packages
cd ~/.pi/agent/npm && npm install

# Agent skills
~/.dotfiles/install-skills.sh

# Credentials (never committed)
cp ~/.dotfiles/pi/auth.json.example ~/.pi/agent/auth.json
chmod 600 ~/.pi/agent/auth.json
```

## Repository structure

```
.dotfiles/
├── install.sh              # Bootstrap script (zero to full setup)
├── install-skills.sh       # Install skills from ai-agent-skills
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── .gitignore
├── zsh/
│   └── .zshrc
├── nvim/
│   ├── init.lua
│   └── lua/
│       ├── config/         # Options, keymaps, lazy bootstrap
│       └── plugins/        # Plugin specs
└── pi/
    ├── agent/
    │   ├── settings.json   # Pi settings
    │   └── npm/
    │       └── package.json
    ├── web-search.json
    └── auth.json.example   # Template (copy locally)
```

## Pi credentials

Create `~/.pi/agent/auth.json` locally (gitignored):

```json
{
  "cursor": {
    "type": "api_key",
    "key": "your-cursor-api-key"
  }
}
```

Or authenticate interactively: `pi` → `/login`

## Security

These files are **never** committed:

| Path | Reason |
|------|--------|
| `**/auth.json` | API keys |
| `pi/agent/sessions/` | Private conversations |
| `pi/agent/bin/` | Downloaded binaries |
| `pi/context-mode/` | Local cache |
| `**/node_modules/` | Dependencies |

If you accidentally commit credentials, **rotate your API keys immediately** and purge git history.

## Updating

```bash
cd ~/.dotfiles
git pull
./install.sh              # Re-link, update deps, and refresh skills
pi update                 # Update Pi and packages
```

## Migrating from setup-pi

This repo replaces the standalone [setup-pi](https://github.com/EnderPuentes/setup-pi) repository. Pi configuration now lives in `.dotfiles/pi/`.

## Related links

- [ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills) — Agent skills collection
- [Pi documentation](https://github.com/earendil-works/pi)
- [Agent Skills specification](https://agentskills.io/specification)
- [Oh My Zsh](https://ohmyz.sh/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)

## License

MIT — see [LICENSE](LICENSE).

## Author

**Ender Puentes** — [GitHub](https://github.com/EnderPuentes)

# dotfiles

Personal development environment by [Ender Puentes](https://github.com/EnderPuentes).

A public, batteries-included setup for **Zsh**, **Neovim**, **Pi coding agent**, and **agent skills** — installable from zero with a single script.

## What's included

| Component | Path | Description |
|-----------|------|-------------|
| **Zsh** | `zsh/.zshrc` | Oh My Zsh + plugins + nvm |
| **Neovim** | `nvim/` | Lazy.nvim, LSP, Telescope, Treesitter |
| **Pi agent** | `pi/` | Cursor SDK, context-mode, web access |
| **Skills** | `skills/` | 13 agent skills for Pi, Cursor, and Claude Code |

### Pi packages

- [pi-cursor-sdk](https://www.npmjs.com/package/pi-cursor-sdk) — Cursor provider
- [context-mode](https://www.npmjs.com/package/context-mode) — Context optimization
- [pi-web-access](https://www.npmjs.com/package/pi-web-access) — Web search & fetch
- [pi-screenshots-picker](https://www.npmjs.com/package/pi-screenshots-picker) — Screenshot tools

Skills from npm packages (context-mode, librarian) install automatically with Pi packages.

### Default skills

| Skill | Purpose |
|-------|---------|
| `typescript` | Type-safe JavaScript patterns |
| `zod` | Schema validation |
| `jsdoc` | API documentation |
| `conventional-commits` | Commit message format |
| `code-review` | UI/React review checklist |
| `find-skills` | Discover installable skills |
| `playwright-cli` | Browser automation |
| `vercel-react-best-practices` | React/Next.js performance |
| `grill-me` | Design stress-testing |
| `pr-description` | PR descriptions (Sanity monorepo) |
| `sanity-*` | Sanity Studio plugin authoring |

## Quick install

### One-liner (clone + install)

```bash
git clone https://github.com/EnderPuentes/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

### From zero on Debian/Ubuntu

The installer handles everything:

1. System packages (`git`, `zsh`, `neovim`, `bat`, `ripgrep`, `fd`)
2. [Oh My Zsh](https://ohmyz.sh/)
3. Zsh plugins (autosuggestions, syntax-highlighting, completions)
4. [nvm](https://github.com/nvm-sh/nvm) + Node.js LTS
5. [Pi coding agent](https://pi.dev)
6. Symlinks for all configs and skills
7. Pi npm package dependencies
8. `auth.json` template (you add your API key)

```bash
curl -fsSL https://raw.githubusercontent.com/EnderPuentes/dotfiles/main/install.sh | bash -s -- --from-clone
```

> **Note:** For the curl one-liner, clone first then run `install.sh` from the repo directory.

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
git clone https://github.com/EnderPuentes/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Link configs
ln -sfn ~/dotfiles/zsh/.zshrc ~/.zshrc
ln -sfn ~/dotfiles/nvim ~/.config/nvim
ln -sfn ~/dotfiles/skills ~/.agents/skills
ln -sfn ~/dotfiles/skills ~/.pi/agent/skills

# Pi config
mkdir -p ~/.pi/agent/npm
ln -sfn ~/dotfiles/pi/agent/settings.json ~/.pi/agent/settings.json
ln -sfn ~/dotfiles/pi/web-search.json ~/.pi/web-search.json
ln -sfn ~/dotfiles/pi/agent/npm/package.json ~/.pi/agent/npm/package.json

# Pi packages
cd ~/.pi/agent/npm && npm install

# Credentials (never committed)
cp ~/dotfiles/pi/auth.json.example ~/.pi/agent/auth.json
chmod 600 ~/.pi/agent/auth.json
```

## Repository structure

```
dotfiles/
├── install.sh              # Bootstrap script (zero to full setup)
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
├── pi/
│   ├── agent/
│   │   ├── settings.json   # Pi settings
│   │   └── npm/
│   │       └── package.json
│   ├── web-search.json
│   └── auth.json.example   # Template (copy locally)
└── skills/
    ├── typescript/
    ├── zod/
    ├── conventional-commits/
    └── ...                 # 13 skills total
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
cd ~/dotfiles
git pull
./install.sh          # Re-link and update deps
pi update             # Update Pi and packages
```

## Migrating from setup-pi

This repo replaces the standalone [setup-pi](https://github.com/EnderPuentes/setup-pi) repository. Pi configuration now lives in `dotfiles/pi/`.

## Related links

- [Pi documentation](https://github.com/earendil-works/pi)
- [Agent Skills specification](https://agentskills.io/specification)
- [Oh My Zsh](https://ohmyz.sh/)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)

## License

MIT — see [LICENSE](LICENSE).

## Author

**Ender Puentes** — [GitHub](https://github.com/EnderPuentes)

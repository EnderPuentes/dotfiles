# Contributing

Thank you for contributing to this open source dotfiles repository!

## Reporting issues

Open an [issue](https://github.com/EnderPuentes/dotfiles/issues) for:

- Broken installation steps
- Missing tools or configuration
- Security concerns (especially `.gitignore` gaps)

**Never** include API keys, session logs, or private paths in issues.

## Pull requests

1. Fork the repository
2. Create a branch from `main`: `git checkout -b feat/your-change`
3. Make focused changes (one concern per PR)
4. Verify no secrets are staged:

   ```bash
   git status
   git diff
   git diff --cached | grep -iE 'api[_-]?key|secret|password|token' && echo "STOP: possible secret" || true
   ```

5. Test locally:

   ```bash
   ./install.sh
   pi
   nvim
   ```

6. Push and open a PR

## Commit messages

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add ghostty terminal config
fix: install fd symlink on Ubuntu
docs: update pi auth setup steps
chore: update neovim plugin versions
```

## What belongs in this repo

**Include:**

- Shell, editor, and Pi configuration
- `install.sh` and documentation
- `.gitignore` updates for new local-only paths

**Never include:**

- `auth.json` or any API keys / tokens
- Session history or conversation logs
- Agent skills (contribute to [ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills) instead)
- `node_modules/`, downloaded binaries, local caches
- Machine-specific paths with private usernames or hostnames

## Adding skills

Agent skills belong in the separate **[ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills)** repository.

To add or update a skill:

1. Open a PR in [ai-agent-skills](https://github.com/EnderPuentes/ai-agent-skills)
2. Run `./install.sh` locally to pull and link the updated skills

Install a single skill with:

```bash
npx skills add https://github.com/EnderPuentes/ai-agent-skills --skill my-skill
```

## Code of conduct

Be respectful and constructive. Keep discussions practical and friendly.

## Questions

Open an issue or reach out on [GitHub](https://github.com/EnderPuentes).

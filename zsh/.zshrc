# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# bat on Debian/Ubuntu (batcat package)
if command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
  alias cat='bat'
fi

# Dotfiles directory (set by install.sh)
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

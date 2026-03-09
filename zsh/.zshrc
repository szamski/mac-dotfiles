# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# ============================================================================
# Environment Variables
# ============================================================================

# Editor
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="$EDITOR"

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Bat
export BAT_THEME=ansi

# FZF + fd integration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# ============================================================================
# ZSH Configuration
# ============================================================================

# History configuration
HISTSIZE=32768
SAVEHIST=32768
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# Zoxide: override command to 'cd' (must be set before plugin loads)
export ZOXIDE_CMD_OVERRIDE=cd

# ============================================================================
# Oh My Zsh
# ============================================================================

# Plugins
plugins=(
  brew
  command-not-found
  macos
  git
  1password
  eza
  fzf
  mise
  python
  zoxide
  zsh-syntax-highlighting
  zsh-autosuggestions
  tldr
  zsh-interactive-cd
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# External Tools Init
# ============================================================================

# Starship prompt
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ============================================================================
# Aliases
# ============================================================================

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# FZF
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias eff='$EDITOR $(ff)'

# Tools
alias d='docker'
n() { if [ "$#" -eq 0 ]; then command nvim .; else command nvim "$@"; fi; }
## alias cat='bat --paging=never'
alias ls='eza -lAh --icons'

# Git shortcuts
alias gs='git status -sb'
alias glog='git log --oneline --graph --decorate -20'

# Utilities
mkcd() { mkdir -p "$1" && cd "$1"; }
port() { lsof -i :"$1"; }

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# ============================================================================
# Bun
# ============================================================================

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export _ZO_DOCTOR=0

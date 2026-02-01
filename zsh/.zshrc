# Powerlevel10k instant prompt (must stay at the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Oh My Zsh ───────────────────────────────────────────

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="nerdfont-complete"

plugins=(
  git
  nvm
  colored-man-pages
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ─── PATH ────────────────────────────────────────────────

export BUN_INSTALL="$HOME/.bun"
export PYENV_ROOT="$HOME/.pyenv"

path=(
  $BUN_INSTALL/bin
  $PYENV_ROOT/bin
  $HOME/.local/bin
  /opt/homebrew/opt/libpq/bin
  /opt/homebrew/opt/mysql-client/bin
  $path
)

# ─── Pyenv (lazy load) ──────────────────────────────────

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

pyenv() {
  unfunction pyenv
  eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  eval "$(command pyenv virtualenv-init -)"
  pyenv "$@"
}

# ─── Bun completions ─────────────────────────────────────

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ─── fzf ─────────────────────────────────────────────────

command -v fzf &>/dev/null && source <(fzf --zsh)

# ─── History ─────────────────────────────────────────────

HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# ─── Aliases ─────────────────────────────────────────────

alias python=python3
alias ..="cd .."
alias ...="cd ../.."
alias ll="ls -la"
alias la="ls -A"
alias ports="lsof -i -P -n | grep LISTEN"
alias myip="curl -s ifconfig.me"
alias reload="source ~/.zshrc"
alias path='echo $PATH | tr ":" "\n"'
alias cleanup="find . -name '.DS_Store' -type f -delete"
alias dps="docker ps"
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcl="docker compose logs -f"

# ─── Powerlevel10k ───────────────────────────────────────

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

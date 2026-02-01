#!/usr/bin/env bash
set -euo pipefail

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null)" || true

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
OBSIDIAN_VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/LifeOS"

# ─── Helpers ───────────────────────────────────────────────

info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$1"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$1"; }

backup_and_link() {
  local src="$1" dest="$2"
  if [ -L "$dest" ]; then
    rm "$dest"
  elif [ -f "$dest" ] || [ -d "$dest" ]; then
    warn "Backing up $dest → ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi
  ln -s "$src" "$dest"
  ok "Linked $dest → $src"
}

# ─── Zsh ───────────────────────────────────────────────────

info "Setting up zsh configs..."
backup_and_link "$DOTFILES/zsh/.zshrc"   "$HOME/.zshrc"
backup_and_link "$DOTFILES/zsh/.p10k.zsh" "$HOME/.p10k.zsh"

# ─── Git ───────────────────────────────────────────────────

info "Setting up git config..."
backup_and_link "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore"

# ─── Ghostty ──────────────────────────────────────────────

info "Setting up Ghostty config..."
mkdir -p "$HOME/.config/ghostty"
backup_and_link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# ─── Neovim ──────────────────────────────────────────────

info "Setting up Neovim config..."
mkdir -p "$HOME/.config/nvim"
backup_and_link "$DOTFILES/nvim/init.lua" "$HOME/.config/nvim/init.lua"

# ─── VS Code ──────────────────────────────────────────────

info "Setting up VS Code settings..."
VSCODE_DIR="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_DIR"
backup_and_link "$DOTFILES/vscode/settings.json" "$VSCODE_DIR/settings.json"

# ─── Obsidian (copy, not symlink) ─────────────────────────

if [ -d "$OBSIDIAN_VAULT" ]; then
  info "Copying Obsidian configs to vault..."
  OBSIDIAN_DEST="$OBSIDIAN_VAULT/.obsidian"
  mkdir -p "$OBSIDIAN_DEST/snippets"

  for f in app.json appearance.json community-plugins.json core-plugins.json hotkeys.json; do
    if [ -f "$DOTFILES/obsidian/$f" ]; then
      cp "$DOTFILES/obsidian/$f" "$OBSIDIAN_DEST/$f"
      ok "Copied $f"
    fi
  done

  for f in "$DOTFILES/obsidian/snippets/"*.css; do
    [ -f "$f" ] && cp "$f" "$OBSIDIAN_DEST/snippets/"
  done
  ok "Copied CSS snippets"
else
  warn "Obsidian vault not found at $OBSIDIAN_VAULT — skipping"
fi

# ─── Oh My Zsh ────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "Oh My Zsh installed"
else
  ok "Oh My Zsh already installed"
fi

# ─── Powerlevel10k ─────────────────────────────────────────

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  ok "Powerlevel10k installed"
else
  ok "Powerlevel10k already installed"
fi

# ─── Zsh plugins ──────────────────────────────────────────

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

if [ ! -d "$ZSH_CUSTOM_DIR/zsh-autosuggestions" ]; then
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_DIR/zsh-autosuggestions"
  ok "zsh-autosuggestions installed"
else
  ok "zsh-autosuggestions already installed"
fi

if [ ! -d "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting" ]; then
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_DIR/zsh-syntax-highlighting"
  ok "zsh-syntax-highlighting installed"
else
  ok "zsh-syntax-highlighting already installed"
fi

# ─── Homebrew bundle ──────────────────────────────────────

if [ -f "$DOTFILES/Brewfile" ]; then
  if command -v brew &>/dev/null; then
    read -rp "Install Homebrew packages from Brewfile? [y/N] " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      info "Running brew bundle..."
      brew bundle --file="$DOTFILES/Brewfile"
      ok "Homebrew packages installed"
    else
      info "Skipping brew bundle"
    fi
  else
    warn "Homebrew not found — skipping brew bundle"
  fi
fi

# ─── Done ─────────────────────────────────────────────────

printf '\n\033[1;32m✓ Dotfiles installed successfully!\033[0m\n'
printf 'Restart your terminal to apply all changes.\n'

# dotfiles

My macOS development environment — Kanagawa-themed, keyboard-driven, minimal noise.

## What's inside

| Tool | Config | Highlights |
|------|--------|------------|
| **Zsh** | `.zshrc`, `.p10k.zsh` | Oh My Zsh + Powerlevel10k, fzf integration, lazy-load pyenv |
| **Git** | `.gitignore_global` | Global ignore for macOS, Node, Python |
| **Ghostty** | `config` | Kanagawa Wave colors, JetBrains Mono, quick terminal (Cmd+`) |
| **Neovim** | `init.lua` | Kanagawa theme, Treesitter, Comment.nvim — minimal for quick edits |
| **VS Code** | `settings.json` | Prettier + ESLint on save, Tailwind class sorting, Kanagawa theme, zero noise |
| **Obsidian** | `app.json`, `appearance.json`, plugins, hotkeys, snippets | JetBrains Mono, custom Kanagawa CSS, Dataview, Kanban |
| **Homebrew** | `Brewfile` | CLI tools, languages, databases, apps, VS Code extensions |
| **macOS** | `macos.sh` | Dock, Finder, keyboard, trackpad, screenshots — one-time setup |

## Structure

```
dotfiles/
├── ghostty/config
├── git/.gitignore_global
├── nvim/init.lua
├── obsidian/
│   ├── app.json
│   ├── appearance.json
│   ├── community-plugins.json
│   ├── core-plugins.json
│   ├── hotkeys.json
│   └── snippets/kanagawa.css
├── vscode/settings.json
├── zsh/.zshrc
├── zsh/.p10k.zsh
├── Brewfile
├── install.sh
└── macos.sh
```

## Install

```bash
git clone https://github.com/IPalSeb/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script will:
- Symlink zsh, git, Ghostty, Neovim and VS Code configs to their expected locations
- Copy Obsidian configs to the vault (no symlink — Obsidian doesn't like them)
- Install Oh My Zsh, Powerlevel10k and zsh plugins if missing
- Optionally run `brew bundle` to install Homebrew packages

Existing files are backed up as `*.backup` before linking.

### macOS preferences

Run once on a fresh Mac:

```bash
./macos.sh
```

Sets Dock, Finder, keyboard repeat speed, trackpad tap-to-click, screenshots without shadow, and disables auto-correct. Requires restart.

## Theme

Everything runs on [Kanagawa](https://github.com/rebelot/kanagawa.nvim) — terminal, editor, notes, and Neovim.

## License

MIT

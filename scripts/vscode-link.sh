#!/bin/bash

# VSCode Settings Link Script
# Crea enlaces simbólicos para mantener sincronización automática

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
DOTFILES_VSCODE_DIR="$(dirname "$0")/../vscode"

echo "🔗 Creating symbolic links for VSCode settings..."

# Backup existing files if they exist
if [ -f "$VSCODE_USER_DIR/settings.json" ]; then
    mv "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup"
    echo "📁 Existing settings.json backed up"
fi

# Create symbolic link for settings.json
ln -sf "$DOTFILES_VSCODE_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
echo "✅ settings.json linked"

# Link keybindings.json if exists
if [ -f "$DOTFILES_VSCODE_DIR/keybindings.json" ]; then
    if [ -f "$VSCODE_USER_DIR/keybindings.json" ]; then
        mv "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json.backup"
    fi
    ln -sf "$DOTFILES_VSCODE_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
    echo "✅ keybindings.json linked"
fi

# Link snippets if exists
if [ -d "$DOTFILES_VSCODE_DIR/snippets" ]; then
    if [ -d "$VSCODE_USER_DIR/snippets" ]; then
        mv "$VSCODE_USER_DIR/snippets" "$VSCODE_USER_DIR/snippets.backup"
    fi
    ln -sf "$DOTFILES_VSCODE_DIR/snippets" "$VSCODE_USER_DIR/snippets"
    echo "✅ snippets linked"
fi

echo "🎉 VSCode symbolic links created!"
echo "💡 Now any changes in dotfiles/vscode/ will sync automatically"

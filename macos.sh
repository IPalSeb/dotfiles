#!/usr/bin/env bash

# macOS defaults — run once on a fresh Mac, then restart.

set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP_FILE="$DOTFILES/macos-defaults.backup"

# ─── Backup current values ────────────────────────────────

echo "Backing up current macOS defaults to $BACKUP_FILE..."

{
  echo "# macOS defaults backup — $(date)"
  echo "# Restore with: bash macos-defaults.backup"
  echo ""

  for key in \
    "com.apple.dock tilesize" \
    "com.apple.dock show-recents" \
    "com.apple.dock launchanim" \
    "com.apple.dock autohide" \
    "com.apple.dock autohide-delay" \
    "com.apple.dock autohide-time-modifier" \
    "NSGlobalDomain AppleShowAllExtensions" \
    "com.apple.finder AppleShowAllFiles" \
    "com.apple.finder ShowPathbar" \
    "com.apple.finder ShowStatusBar" \
    "com.apple.finder FXPreferredViewStyle" \
    "com.apple.finder NewWindowTarget" \
    "com.apple.finder FXEnableExtensionChangeWarning" \
    "com.apple.finder FXDefaultSearchScope" \
    "NSGlobalDomain KeyRepeat" \
    "NSGlobalDomain InitialKeyRepeat" \
    "NSGlobalDomain ApplePressAndHoldEnabled" \
    "com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking" \
    "NSGlobalDomain NSAutomaticCapitalizationEnabled" \
    "NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled" \
    "NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled" \
    "NSGlobalDomain NSAutomaticDashSubstitutionEnabled" \
    "NSGlobalDomain NSAutomaticSpellingCorrectionEnabled" \
    "com.apple.screencapture type" \
    "com.apple.screencapture disable-shadow" \
    "NSGlobalDomain AppleShowScrollBars"; do
    domain="${key%% *}"
    prop="${key#* }"
    val=$(defaults read "$domain" "$prop" 2>/dev/null) && \
      echo "defaults write $domain $prop '$val'" || \
      echo "# $domain $prop — not set (default)"
  done
} > "$BACKUP_FILE"

echo "✓ Backup saved"
echo ""
echo "Applying macOS defaults..."

# ─── Dock ────────────────────────────────────────────────

defaults write com.apple.dock tilesize -int 39
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3

# ─── Finder ──────────────────────────────────────────────

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# ─── Keyboard ───────────────────────────────────────────

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# ─── Trackpad ───────────────────────────────────────────

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ─── Text input ─────────────────────────────────────────

defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ─── Screenshots ─────────────────────────────────────────

defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ─── UI ─────────────────────────────────────────────────

defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# ─── Restart affected apps ──────────────────────────────

for app in "Dock" "Finder" "SystemUIServer"; do
  killall "$app" &>/dev/null || true
done

echo "✓ macOS defaults applied. Some changes require logout/restart."

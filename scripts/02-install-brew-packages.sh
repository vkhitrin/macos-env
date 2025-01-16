#!/usr/bin/env bash
set -eo pipefail

source ./scripts/common.sh

# Verify brew is installed
which brew >/dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Disable brew analytics
print_padded_title "Brew - Disable Analytics"
brew analytics off

# Update brew
print_padded_title "Brew - Update"
brew update

# Install brew packages
print_padded_title "Brew - Install/Update"
[ -f Brewfile ] || error_exit "No Brewfile is found"
brew bundle --quiet --file=Brewfile

# print_padded_title "Brew - Start Services"
# brew services start borders

print_padded_title "Brew - Workarounds"
xattr -d com.apple.quarantine /opt/homebrew/bin/clickhouse || true

# Soft links
print_padded_title "Brew - Soft Links"
ln -sf /opt/homebrew/bin/yt-dlp /opt/homebrew/bin/youtube-dl
ln -sf /opt/homebrew/bin/tofu "$HOME/.local/bin/terraform"

# Cleanup brew
print_padded_title "Brew - Cleanup"
brew cleanup --prune=all
brew autoremove

# Brew completions
print_padded_title "Brew - Completions"
# Link shipped brew completions
brew completions link
# Add completions to tools that are not shipped by zsh-completions
podman completion zsh -f /opt/homebrew/share/zsh-completions/_podman
gh completion -s zsh >/opt/homebrew/share/zsh-completions/_gh
# [ -f "/opt/homebrew/share/zsh-completions/_glab" ] || glab completion -s zsh > /opt/homebrew/share/zsh-completions/_glab
# [ -f "/opt/homebrew/share/zsh-completions/_bw" ] || bw completion --shell zsh > /opt/homebrew/share/zsh-completions/_bw
mise completion zsh >/opt/homebrew/share/zsh-completions/_mise
snipkit completion zsh >/opt/homebrew/share/zsh-completions/_snipkit
gitlab-ci-local --completion >/opt/homebrew/share/zsh-completions/_gitlab-ci-local
istioctl completion zsh >/opt/homebrew/share/zsh-completions/_istioctl-local
# [ -f "/opt/homebrew/share/zsh-completions/_virtctl" ] || virtctl completion zsh > /opt/homebrew/share/zsh-completions/_virtctl
print_padded_title "Brew - Notes"
echo "Please run the following to enable completions:"
echo "compaudit | xargs chmod g-w"
echo "autoload bashcompinit && bashcompinit"
echo "autoload compinit && compinit"

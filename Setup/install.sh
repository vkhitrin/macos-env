#!/usr/bin/env bash
set -eo pipefail

# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2
    exit "${2:-1}"
}

# Print padded title based on terminal column size
function print_padded_title {
    termwidth="$(tput cols)"
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# Make sure script isn't executed on non macOS systems
print_padded_title "Prerequisites Check"
if [[ $(uname) != "Darwin" ]];then
    error_exit "Please make sure you're running on macOS"
fi

# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Ensure iCloud is enabled on system
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" ~/Library/Preferences/MobileMeAccounts.plist | grep MOBILE_DOCUMENTS -A3 -B3 | grep 'Enabled = true' > /dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"

# If Xcode is not installed, we wish to skip Developer related items from Spotlight search
print_padded_title "Workarounds - /Applications/Xcode.app"
[ -d "$HOME/.iCloudDrive" ] || mkdir /Applications/Xcode.app

# Create symlink to iCloud Drive
print_padded_title "Directories - .iCloud"
[ -d "$HOME/.iCloudDrive" ] || ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" "$HOME/.iCloudDrive"

# Create Directories
print_padded_title "Directories - Projects"
mkdir -p "$HOME/Projects/Automation/" "$HOME/Projects/Development" "$HOME/Projects/Containers" "$HOME/Documents/Screenshots"

print_padded_title "Directories - .local"
mkdir -p "$HOME/.local/bin"

# Disable brew analytics
print_padded_title "Brew - Disable Analytics"
brew analytics off

# Update brew
print_padded_title "Brew - Update"
brew update

# Install brew packages
print_padded_title "Brew - Install/Update"
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
brew bundle --quiet --file=./Setup/Brewfile

# Workaround, reinstall google-chat-electoron without gatekeeper
print_padded_title "Brew - Reinstall google-chat-electron Without Quarentine"
brew reinstall --no-quarantine google-chat-electron

# Soft links
print_padded_title "Files - Soft Links"
ln -s /opt/homebrew/bin/yt-dlp /opt/homebrew/bin/youtube-dl

# Install libguestfs from local Formula
# [ -f ./Setup/homebrew/libguestfs.rb ] || error_exit "No libguestfs formula found"
# echo "Copying portableendian.h to homebrew"
# cp ./Setup/homebrew/portableendian.h /opt/homebrew/include/
# echo "Installing libguestfs"
# brew install -v --formula ./Setup/homebrew/libguestfs.rb

# Cleanup brew
print_padded_title "Brew - Cleanup"
brew cleanup
brew autoremove

# Brew completions
print_padded_title "Brew - Completions"
# Link shipped brew completions
brew completions link
# Add completions to tools that are not shipped by zsh-completions
[ -f "/opt/homebrew/share/zsh-completions/_podman" ] || podman completion zsh -f /opt/homebrew/share/zsh-completions/_podman
[ -f "/opt/homebrew/share/zsh-completions/_limactl" ] || limactl completion zsh > /opt/homebrew/share/zsh-completions/_limactl
[ -f "/opt/homebrew/share/zsh-completions/_oc" ] || oc completion zsh > /opt/homebrew/share/zsh-completions/_oc
[ -f "/opt/homebrew/share/zsh-completions/_gh" ] || gh completion -s zsh > /opt/homebrew/share/zsh-completions/_gh
[ -f "/opt/homebrew/share/zsh-completions/_glab" ] || glab completion -s zsh > /opt/homebrew/share/zsh-completions/_glab
[ -f "/opt/homebrew/share/zsh-completions/_bw" ] || bw completion --shell zsh > /opt/homebrew/share/zsh-completions/_bw
[ -f "/opt/homebrew/share/zsh-completions/_rtx" ] || rtx completion zsh > /opt/homebrew/share/zsh-completions/_rtx
[ -f "/opt/homebrew/share/zsh-completions/_snipkit" ] || snipkit completion zsh > /opt/homebrew/share/zsh-completions/_snipkit
[ -f "/opt/homebrew/share/zsh-completions/_virtctl" ] || virtctl completion zsh > /opt/homebrew/share/zsh-completions/_virtctl

# Copy dotfiles to home directory
print_padded_title "Config - Restore Files"
cp -r -f .zshenv .zshrc .config ~

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
print_padded_title "defaults - Quit System Preferences"
osascript -e 'tell application "System Preferences" to quit'

# Install macOS defaults
print_padded_title "defaults - Configure defaults"
bash ./Setup/macos_defaults.sh install

print_padded_title "defaults - Configure defaults"
killall -q Finder || true
killall -q Dock || true
killall -q Safari || true

# Configure mackup
# mackup will be brokeon on macOS Sonoma (14) https://github.com/lra/mackup/issues/1924
print_padded_title "Mackup - Copy Configuration"
cp .mackup.cfg ~/.mackup.cfg
rm -rf "$HOME/.mackup"; cp -r .mackup "$HOME/.mackup"

# Restore using mackup
print_padded_title "Mackup - Restore"
mackup -vf restore

# Upgrade pip using native system's Python
print_padded_title "Python - Install Packages On System's Python"
/usr/bin/python3 -m pip install pip lxml

# Insall python packages using brew's Python
print_padded_title "Python - Install Packages On brew's Python"
pip3 install -Uqqq virtualenv pip neovim python-lsp-server[all] rst-language-server qmk  esbonio python-openstackclient osc-placement gnureadline

# Install npm modules
print_padded_title "NodeJS - Install Modules Globally"
npm install -g git-open neovim

# Install Tmux Plugin Manager
print_padded_title "tmux - Install Plugin Manager 'tpm'"
[ -d "$HOME/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Install tmux plugins
print_padded_title "tmux - Install Plugins"
"$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh"

# Install local groovy-language-server
print_padded_title "groovy-language-server - Install"
if [[ ! -d $HOME/.local/groovy-language-server ]];then
    git clone "https://github.com/GroovyLanguageServer/groovy-language-server.git" "$HOME/.local/groovy-language-server"
    cd "$HOME/.local/groovy-language-server; JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home" ./gradlew build
fi

# Install Apple's SF Mono font
print_padded_title "Fonts - Apple SF Mono Font"
SF_MONO_FONTS=$(fc-list : file family | grep 'SF Mono')
if [ -z "$SF_MONO_FONTS" ];then
    curl https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg -o /tmp/SF-Mono.dmg
    hdiutl mount /tmp/SF-Mono.dmg
    sudo installer -pkg /Volumes/SFMonoFonts/SF\ Mono\ Fonts.pkg -target /
    hdiutil unmount $(mount | grep SFMono | cut -d " " -f1)
fi

# Add SSH keys to ssh-agent
print_padded_title "ssh-agent - Start Agent"
pgrep ssh-agent > /dev/null 2>/dev/null  || eval "$(ssh-agent)"

print_padded_title "ssh-agent - Secure Permissions"
find "$HOME/.config/personal_keys/private" -type f -exec chmod 0400 {} \;

print_padded_title "ssh-agent - Add Keys"
#ssh-add "$HOME/.config/personal_keys/private/*"
find "$HOME/.config/personal_keys/private" -type f -exec ssh-add {} \;

# ZSH stuff
print_padded_title "zsh - compaudit"
zsh -c 'zsh /usr/share/zsh/5.9/functions/compaudit | xargs chmod g-w'

print_padded_title "NOTES"
echo "NOTE: Reminder of macOS 'ByHost' preferences, if relevant restore them to '$HOME/Library/Preferences/ByHost/'"

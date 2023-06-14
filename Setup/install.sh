#!/usr/bin/env bash

set -eo pipefail

# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2
    exit "${2:-1}"
}

function print_padded_title {
    termwidth="$(tput cols)"
    padding="$(printf '%0.1s' ={1..500})"
    printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

print_padded_title "Prerequisites Check"
if [[ $(uname) != "Darwin" ]];then
    error_exit "Please make sure you're running on macOS"
fi
# Make sure script isn't executed on non macOS systems
# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"
/usr/libexec/PlistBuddy -c "print :Accounts:0:Services:" ~/Library/Preferences/MobileMeAccounts.plist | grep MOBILE_DOCUMENTS -A3 -B3 | grep 'Enabled = true' > /dev/null 2>/dev/null || error_exit "iCloud is not enabled on the system"


# Create symlink to iCloud Drive
print_padded_title "Directories - .iCloud"
[ -d "$HOME/.iCloudDrive" ] || ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/" $HOME/.iCloudDrive

print_padded_title "Directories - Projects"

# Create Directories
mkdir -p $HOME/Projects/Automation/ $HOME/Projects/Development $HOME/Projects/Containers $HOME/Documents/Screenshots

print_padded_title "Brew - Disable Analytics"
# Disable brew analytics
brew analytics off

print_padded_title "Brew - Update"
# Update brew
brew update

print_padded_title "Brew - Install/Update"
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
brew bundle --quiet --file=./Setup/Brewfile

print_padded_title "Brew - Reinstall google-chat-electron Without Quarentine"
brew reinstall --no-quarantine google-chat-electron

# Install libguestfs from local Formula
# [ -f ./Setup/homebrew/libguestfs.rb ] || error_exit "No libguestfs formula found"
# echo "Copying portableendian.h to homebrew"
# cp ./Setup/homebrew/portableendian.h /opt/homebrew/include/
# echo "Installing libguestfs"
# brew install -v --formula ./Setup/homebrew/libguestfs.rb

print_padded_title "Brew - Cleanup"
brew cleanup;brew autoremove

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

# Backup current dotfiles
print_padded_title "Config - Restore .zshrc"
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bk

print_padded_title "Config - Restore Files"
# Copy dotfiles to home directory
cp -r -f .zshenv .zshrc .config ~

print_padded_title "defaults - Quit System Preferences"
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

print_padded_title "defaults - Configure defaults"
# Install defaults
bash ./Setup/macos_defaults.sh install

print_padded_title "defaults - Configure defaults"
killall -q Finder || true
killall -q Dock || true
killall -q Safari || true
# Execute apple script

print_padded_title "Mackup - Copy Configuration"
# Copy mackup config file
cp .mackup.cfg ~/.mackup.cfg
# Copy mackup applications config file
rm -rf $HOME/.mackup; cp -r .mackup $HOME/.mackup

print_padded_title "Mackup - Restore"
# Restore using mackup
mackup -vf restore

# Upgrade pip
print_padded_title "Python - Install Packages On System's Python"
/usr/bin/python3 -m pip install pip lxml

print_padded_title "Python - Install Packages On brew's Python"
pip3 install -Uqqq virtualenv pip neovim python-lsp-server[all] pip install rst-language-server qmk  esbonio # use brew python

# Install npm modules
print_padded_title "NodeJS - Install Modules Globally"
npm install -g git-open neovim


print_padded_title "neovim - Install Plugin Manager 'vim-plug'"
# Install vim-plug
[ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] || sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

print_padded_title "neovim - Install Plugins"
nvim --headless +PlugInstall +qall

# Install Tmux Plugin Manager
print_padded_title "tmux - Install Plugin Manager 'tpm'"
[ -d $HOME/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

print_padded_title "tmux - Install Plugins"
$HOME/.tmux/plugins/tpm/scripts/install_plugins.sh

# Install local groovy-language-server
print_padded_title "groovy-language-server - Install"
if [[ ! -d $HOME/.local/groovy-language-server ]];then
    git clone "https://github.com/GroovyLanguageServer/groovy-language-server.git" $HOME/.local/groovy-language-server
    cd $HOME/.local/groovy-language-server; JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home ./gradlew build
fi

# Install Apple's SF Mono font
# https://devimages-cdn.apple.com/design/resources/download/SF-Mono.dmg

# Add SSH keys to ssh-agent
print_padded_title "ssh-agent - Start Agent"
pgrep ssh-agent > /dev/null 2>/dev/null  || eval "$(ssh-agent)"

print_padded_title "ssh-agent - Secure Permissions"
chmod 0600 $HOME/.config/personal_keys/private/*

print_padded_title "ssh-agent - Add Keys"
ssh-add $HOME/.config/personal_keys/private/*

# ZSH stuff
print_padded_title "zsh - compaudit"
zsh -c 'zsh /usr/share/zsh/5.9/functions/compaudit | xargs chmod g-w'

print_padded_title "ssh-agent - Add Keys"

print_padded_title "NOTES"
echo "NOTE: Reminder of macOS 'ByHost' preferences, if relevant restore them to '$HOST/Library/Preferences/ByHost/'"

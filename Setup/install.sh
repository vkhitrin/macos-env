#!/usr/bin/env bash

set -eo pipefail

# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2
    exit "${2:-1}"
}

# Make sure script isn't executed on non macOS systems
if [[ $(uname) != "Darwin" ]];then
    error_exit "Please make sure you're running on macOS"
fi

# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Disable brew analytics
brew analytics off

# Upgrade and update brew
brew upgrade;brew update

# Verify existence of Brewfile
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
echo "Installing brew taps/casks/apps:"
brew bundle --quiet --file=./Setup/Brewfile

# Install libguestfs from local Formula
# [ -f ./Setup/homebrew/libguestfs.rb ] || error_exit "No libguestfs formula found"
# echo "Copying portableendian.h to homebrew"
# cp ./Setup/homebrew/portableendian.h /opt/homebrew/include/
# echo "Installing libguestfs"
# brew install -v --formula ./Setup/homebrew/libguestfs.rb

echo "Cleanup brew"
brew cleanup;brew autoremove

# Install amphetamine enhancer
if [[ ! $(ls -l /Applications | grep 'Amphetamine Enhancer') ]]; then
    echo "Downloading and installing Amphetamine Enhancer"
    wget https://github.com/x74353/Amphetamine-Enhancer/raw/master/Releases/Current/Amphetamine%20Enhancer.dmg -O /tmp/amphetamine_enhancer.dmg
    hdiutil attach /tmp/amphetamine_enhancer.dmg
    cp -R /Volumes/Amphetamine\ Enhancer/Amphetamine\ Enhancer.app /Applications
    hdiutil unmount /Volumes/Amphetamine\ Enhancer
fi

# Install chipmunk log analyzer & viewer
if [[ ! $(ls -l /Applications | grep 'chipmunk') ]]; then
    echo "Downloading chipmunk (log analyzer & viewer)"
    wget https://github.com/esrlabs/chipmunk/releases/download/2.26.3/chipmunk@2.26.3-darwin-portable.tgz -O /tmp/chipmunk-portable.tgz
    tar -xvf /tmp/chipmunk-portable.tgz -C /tmp/
    cp -R /tmp/chipmunk.app /Applications
fi

# Backup current dotfiles
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bk

# Copy dotfiles to home directory
cp -r -f .zshenv .zshrc .config ~

# Apply defaults to applications

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Install defaults
bash ./Setup/macos_defaults.sh install

# Execute apple script
bash ./Setup/apple_script.sh install

# Copy mackup config file
cp .mackup.cfg ~/.mackup.cfg

# Copy mackup applications config file
rm -rf ~/.mackup; cp -r .mackup ~/.mackup

# Restore using mackup
mackup -f restore

# Upgrade pip
echo "Upgrading pip and related packages"
/usr/bin/python3 -m pip install lxml # Instal lxml on OS python
pip3 install -Uqqq virtualenv pip neovim python-lsp-server[all] pip install rst-language-server qmk # use brew python

# Link shipped brew completions
brew completions link

# Install vim-plug
[ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] || sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Add completions to tools that are not shipped by zsh-completions
[ -f "/opt/homebrew/share/zsh-completions/_podman" ] || podman completion zsh -f /opt/homebrew/share/zsh-completions/_podman
[ -f "/opt/homebrew/share/zsh-completions/_limactl" ] || limactl completion zsh > /opt/homebrew/share/zsh-completions/_limactl
[ -f "/opt/homebrew/share/zsh-completions/_oc" ] || oc completion zsh > /opt/homebrew/share/zsh-completions/_oc
[ -f "/opt/homebrew/share/zsh-completions/_gh" ] || gh completion -s zsh > /opt/homebrew/share/zsh-completions/_gh
[ -f "/opt/homebrew/share/zsh-completions/_glab" ] || glab completion -s zsh > /opt/homebrew/share/zsh-completions/_glab
[ -f "/opt/homebrew/share/zsh-completions/_bw" ] || bw completion --shell zsh > /opt/homebrew/share/zsh-completions/_bw

# Install local groovy-language-server
if [[ ! -d $HOME/.local/groovy-language-server ]];then
    git clone "https://github.com/GroovyLanguageServer/groovy-language-server.git" $HOME/.local/groovy-language-server
    cd $HOME/.local/groovy-language-server; JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home ./gradlew build
fi

# Add SSH keys to ssh-agent
ssh-add ~/.config/personal_keys/private/*

# Create Directory Structures
mkdir -p ~/Projects/Automation/ ~/Projects/Development ~/Projects/Containers

echo "Please run 'compaudit | xargs chmod g-w' if needed."

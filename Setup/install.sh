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

# Verify existence of Brewfile
[ -f ./Setup/Brewfile ] || error_exit "No Brewfile is found"
echo "Installing brew taps/casks:"
brew bundle --file=./Setup/Brewfile

# Install podman-compose
echo "Installing podman-compose via pip3"
pip3 install podman-compose

# Add completions to tools that are not shipped by zsh-completions
[ -f /usr/local/share/zsh-completions/_podman ] || podman completion zsh -f /usr/local/share/zsh-completions/_podman
[ -f /usr/local/share/zsh-completions/_limactl ] || limactl completion zsh > /usr/local/share/zsh-completions/_limactl

# Backup current dotfiles
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bk

# Copy dotfiles to home directory
cp -r -f .zshrc .config ~

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

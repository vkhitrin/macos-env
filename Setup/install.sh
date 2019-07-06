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

# Backup current dotfiles
[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bk
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf ~/.tmux.conf.bk

# Copy dotfiles to home directory
cp -r -f .zshrc .config .tmux.conf ~

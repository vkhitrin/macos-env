# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2 
    exit "${2:-1}"
}

# Make sure script isn't executed on non macOS systems
if [[ $(uname) != "Darwin" ]];then
    echo "Please make sure you're running on macOS"
    exit 1
fi

# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Verify existence of recipe file
[ -f ./Setup/uninstall_recipe.txt ] || error_exit "No recipe file is found"

# Itterate over recipe file
while read command; do
    echo "Executing '$command'"; $command
done <./Setup/uninstall_recipe.txt

# Remove Vim Plug
[ -d ~/.local/share/nvim ] && rm -rf ~/.local/share/nvim

# Restore from backup if exists
[ -f ~/.bashrc.bk ] && mv ~/.bashrc.bk ~/.bashrc
[ -f ~/.bash_profile.bk ] && mv ~/.bash_profile.bk ~/.bash_profile
[ -f ~/.tmux.conf.bk ] && mv ~/.tmux.conf.bk ~/.tmux.conf
[ -f ~/.tmux.conf.local.bk ] && mv ~/.tmux.conf.bk ~/.tmux.conf.local

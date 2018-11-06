# Function which prints an error message and then returns exit code 1
function error_exit {
    echo "$1" >&2 
    exit "${2:-1}"
}

# Make sure script isn't executed on non MacOS systems
if [[ $(uname) != "Darwin" ]];then
    echo "Please make sure you're running on MacOS"
    exit 1
fi

# Verify brew is installed
which brew > /dev/null 2>/dev/null || error_exit "Brew is not installed, please download from https://brew.sh/"

# Verify existence of recipe file
[ -f ./Setup/install_recipe.txt ] || error_exit "No recipe file is found"

# Itterate over recipe file
while read command; do
    echo "Executing '$command'"; $command
done <./Setup/install_recipe.txt

# Download Vim Plug
[ -d ~/.local/share/nvim ] || curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
			  		   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || error_exit "Failed to download Vim Plug"

# Backup current dotfiles
cp ~/.bashrc ~/.bashrc.bk
cp ~/.bash_profile ~/.bash_profile.bk

# Copy dotfiles to home directory
cp -r -f .bashrc .bash_profile .config

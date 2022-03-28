# Fix editor issue with zsh https://unix.stackexchange.com/questions/602732/how-do-i-figure-out-what-just-broke-my-zsh-shell-beginning-of-line-and-end-of-li
bindkey -e

# Source aliases
[ -f $HOME/.config/assets/aliases ] && source $HOME/.config/assets/aliases

# Source zsh tweaks
[ -f $HOME/.config/assets/zsh ] && source $HOME/.config/assets/zsh

# Source hstr
[ -f $HOME/.config/assets/hstr ] && source $HOME/.config/assets/hstr


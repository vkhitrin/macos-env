# Fix editor issue with zsh https://unix.stackexchange.com/questions/602732/how-do-i-figure-out-what-just-broke-my-zsh-shell-beginning-of-line-and-end-of-li
bindkey -e

# Source zsh config
[ -f $HOME/.config/zsh/config ] && source $HOME/.config/zsh/config

# Source aliases
[ -f $HOME/.config/zsh/aliases ] && source $HOME/.config/zsh/aliases

# Source hstr
[ -f $HOME/.config/zsh/hstr ] && source $HOME/.config/zsh/hstr

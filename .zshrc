# Source aliases
[ -f $HOME/.config/assets/aliases ] && source $HOME/.config/assets/aliases

# Source zsh tweaks
[ -f $HOME/.config/assets/zsh ] && source $HOME/.config/assets/zsh

# Source hstr
[ -f $HOME/.config/assets/hstr ] && source $HOME/.config/assets/hstr

# Source zsh-completion
if [[ -d /usr/local/share/zsh-completions ]];then
    fpath=(/usr/local/share/zsh-completions $fpath)
    autoload -U compinit promptinit
    compinit
fi

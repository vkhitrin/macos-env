# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Source bash-completion
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion 

# Source sensible-bash
[ -f $HOME/.config/assets/sensible.bash ] && source $HOME/.config/assets/sensible.bash > /dev/null 2>/dev/null

# Source aliases
[ -f $HOME/.config/assets/aliases ] && source $HOME/.config/assets/aliases

# Editor Discovery
which vim > /dev/null 2>&1 && alias vi='vim' && EDITOR="vim"
which nvim > /dev/null 2>&1 && alias vim='nvim' && EDITOR="nvim"
export EDITOR && export VISUAL=$EDITOR

# Source bullet train prompt
[ -f $HOME/.config/assets/gbt ] && source $HOME/.config/assets/gbt

# Source history enhancements
[ -f $HOME/.config/assets/hstr ] && source $HOME/.config/assets/hstr

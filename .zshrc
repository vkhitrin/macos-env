# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=/usr/local/sbin:$PATH

# Source aliases
[ -f $HOME/.config/assets/aliases ] && source $HOME/.config/assets/aliases

# Source zsh-completion
[ -f /usr/local/share/zsh-completions ] && fpath=(/usr/local/share/zsh-completions $fpath); autoload -U compinit promptinit;compinit

# Source zsh-autosuggestions
[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Source zsh tweaks
[ -f $HOME/.config/assets/zsh ] && source $HOME/.config/assets/zsh

# Source hstr
[ -f $HOME/.config/assets/hstr ] && source $HOME/.config/assets/hstr

# Terminal Editor Discovery
which vim > /dev/null 2>&1 && alias vi='vim'
which nvim > /dev/null 2>&1 && alias vim='nvim'

# Set default editor
EDITOR='subl --wait'
export EDITOR && export VISUAL=$EDITOR

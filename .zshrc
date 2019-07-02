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

# Editor Discovery
which vim > /dev/null 2>&1 && alias vi='vim' && EDITOR="vim"
which nvim > /dev/null 2>&1 && alias vim='nvim' && EDITOR="nvim"
export EDITOR && export VISUAL=$EDITOR

# Activate pyenv if present
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv init -)"; fi

# Source zsh-syntax-highlighting
[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source aliases
[ -f $HOME/.config/assets/aliases ] && source $HOME/.config/assets/aliases

# Source zsh tweaks
[ -f $HOME/.config/assets/zsh ] && source $HOME/.config/assets/zsh

# Source hstr
[ -f $HOME/.config/assets/hstr ] && source $HOME/.config/assets/hstr

# Source zsh-completion
if [[ -d "$(brew --prefix)/share/zsh-completions" ]];then
    FPATH="$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit promptipnit
    compinit
fi

# Enable powerlevel10k theme
if [[ -f "$(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" ]];then
    source "$(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme"
    source ~/.p10k.zsh
fi

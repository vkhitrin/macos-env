# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export PATH=/opt/homebrew/bin/:$/opt/homebrew/sbin/:/usr/local/sbin:$PATH

# History
export HISTFILE=~/.zsh_history
export HISTSIZE=10000000
export SAVEHIST=10000000

# Set default editor
export EDITOR='nvim'
export VISUAL=$EDITOR

# unset
unset SSH_AUTH_SOCK # Not aware of anything that uses it during my workflow https://github.com/containers/podman/issues/12728
unset SSH_SK_PROVIDER # Not aware of anything that uses it during my workflow

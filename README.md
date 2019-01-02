# Personal macOS dotfiles + tools used that are part of my workflow

![Terminal](https://i.imgur.com/zsUKBHt.png)

Using macOS High Sierra 10.13.6 on Desktop

Using macOS Mojave 10.14 on Laptop

## Mackup vs Git

Mackup has the option to backup bash, neovim and more dotfiles.

In my personal preference, I rather have my dotfiles in git because dotfiles are a big part part of my workflow and they're changed often and having a proper history and version control is important to me.

Application configuration are more 'static' as a part of my workflow and they're not changed as often as dotfiles. Mackup is a great solution since it's less important to document the changes.

## Installation

**Note:** Currently a simple install/uninstall scripts are present, still WIP.

**Note:** Will run only on macOS.

**Note:** Doesn't download neovim plugins.

In order to install dot files and CLI utilities, use `make install`.

In order to uninstall dot files and CLI utilities, use `make uninstall`.

## CLI

* [git](https://git-scm.com/) - Version control tool.
* [brew](https://brew.sh/) - Package manager for macOS.
* [hh](https://github.com/dvorka/hstr) - History prompt in bash.
* [gbt](https://github.com/jtyr/gbt) - Prompt bullet train for bash.
* bash-completion - Auto completion for bash.
* [bash-sensible](https://github.com/mrzool/bash-sensible) - Bash enhancements.
* [nvim](https://github.com/neovim/neovim) - NeoVim.
* [exa](https://github.com/ogham/exa) - An ls alternative.
* [git-review](https://www.mediawiki.org/wiki/Gerrit/git-review) - Gerrit tool for git.
* [fpp](https://github.com/facebook/PathPicker) - PathPicker utility.
* [ipmitool](https://github.com/ipmitool/ipmitool) - Control IPMI.
* [mackup](https://github.com/lra/mackup) - Backup macOS app configuration.
* [ipcalc](http://jodies.de/ipcalc-archive/ipcalc-0.41/ipcalc) - IP calculator CLI tool.
* [NodeJS](https://nodejs.org/en/) - JavaScript runtime.
* [lighttpd](https://redmine.lighttpd.net/projects/lighttpd/wiki) - Light httpd server.
* [ag](https://github.com/ggreer/the_silver_searcher) - The Silver Searcher, code searching tool.
* [tmux](https://github.com/tmux/tmux) - Terminal multiplexer.
* [bat](https://github.com/sharkdp/bat) - Cat clone.
* [jq](https://github.com/stedolan/jq) - CLI JSON processor.

## Vim

* [Vim Plug](https://github.com/junegunn/vim-plug) - Plugin manager for vim.
* [Airlne](https://github.com/vim-airline/vim-airline) - Bullet train for vim.
* [Airline Themes](https://github.com/vim-airline/vim-airline-themes) - Themes for Airline.
* [Nerdtree](https://github.com/scrooloose/nerdtree) - Tree explorer for vim.
* [Nerdtree git plugin](https://github.com/Xuyuanp/nerdtree-git-plugin) - Git status for nerdtree.
* [VimDevIcons](https://github.com/ryanoasis/vim-devicons) - Add devicons to vim plugins.
* [CtrlP](https://github.com/ctrlpvim/ctrlp.vim) - Fuzzy searcher for vim.

## Applications

* [Firefox](https://www.mozilla.org/en-US/firefox/) - Browser.
* [iTerm2 Beta](https://www.iterm2.com/downloads.html) - Terminal.
* [Itsyscal](https://www.mowglii.com/itsycal/) - Menu bar calendar.
* [Setapp](https://setapp.com/):
  * [Paste](https://pasteapp.me/) - Clipboard manager.
  * [BetterTouchTool](https://folivora.ai/) - Customize input devices + Window snapping.
  * [Bartender](https://www.macbartender.com/) - Organize macOS menu bar.
  * [Gifox](https://gifox.io/) - Gif recording.
  * [Cloud Mounter](https://cloudmounter.net/) - Mount cloud/network drives.
* [Tunnelblick](https://tunnelblick.net/) - OpenVPN client.
* [KeePassXC](https://keepassxc.org/) - KeePass client.
* [Krita](https://krita.org/en/) - Image manipulation.
* [Textual](https://github.com/Codeux-Software/Textual) - IRC client.
* [Docker](https://www.docker.com/) - Container runtime.

## Hardware

Refer to [Hardware README](https://github.com/VKhitrin/macos-env/tree/master/Hardware).

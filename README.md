# macos-env

Personal dotfiles and tools.

**Note:** The files in this repository are relevant to my personal workflow!

Using macOS Big Monterey 12 on Macbook Pro M1 Pro.

## Mackup vs Git

Mackup has the option to backup bash and more dotfiles.

In my personal preference, I rather have my dotfiles in git because dotfiles are a big part part of my workflow and are changed often and having a proper version control is important to me.

Application configuration is more 'static' and not changed as often as dotfiles. Mackup is a great solution since its less important to document the changes.

## Installation

In order to install dot files and CLI utilities, use `make install`.

In order to uninstall dot files and CLI utilities, use `make uninstall`.

In order to bootstrap Fedora CoreOS VM (to be used for podman), use `make bootstrap-lima`.

In order to teardown Fedora CoreOS VM, use `make teardown-lima`.

## Hardware

Refer to [Hardware README](/Hardware).

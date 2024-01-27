.DEFAULT: help
.PHONY: install-brew install-extra install-directories install-defaults install-tmux-tpm restore-config create-utm-arch-linux-vm create-utm-ubuntu-linux-vm

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install-directories: ##Installs directories
	@./Setup/scripts/install-directories.sh

install-brew: ##Installs brew dependencies
	@./Setup/scripts/install-brew.sh

install-extra: ##Installs extra dependencies
	@./Setup/scripts/install-extra.sh

install-defaults: ##Installs macOS defaults
	@./Setup/scripts/install-defaults.sh

install-tmux-tpm: ##Installs tmux plugin manager
	@./Setup/scripts/install-tmux-tpm.sh

restore-config: ##Restores configuration
	@./Setup/scripts/restore-config.sh

create-utm-arch-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@./Setup/scripts/create-utm-arch-linux-vm.sh

create-utm-ubuntu-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@./Setup/scripts/create-utm-ubuntu-linux-vm.sh

.DEFAULT: help
.PHONY: install-brew install-extra install-directories install-defaults install-tmux-tpm restore-config create-utm-arch-linux-vm create-utm-ubuntu-linux-vm

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | sed -e 's/\(\:.*\#\#\)/\:\ /' | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

install-directories: ##Installs directories
	@./scripts/00-create-directories.sh

set-defaults: ##Sets macOS defaults
	@./scripts/01-set-defaults.sh

install-brew-packages: ##Installs brew packages
	@./scripts/02-install-brew-packages.sh

fetch-dotfiles: ##Fetch dotfiles
	@./scripts/03-fetch-dotfiles.sh

install-python-packages: ##Installs python packages
	@./scripts/04-install-python-packages.sh

install-tmux-tpm: ##Restores configuration
	@./scripts/05-install-tmux-tpm.sh

restore-config: ##Restores config
	@./scripts/06-restore-config.sh

install-k8s-plugins: ##Installs Kubernetes related plugins
	@./scripts/07-install-k8s-plugins.sh

catppuccin-theme: ##Catppuccin theming
	@./scripts/08-catppuccin-theme.sh

private-customizations: ##Private customizations
	@./scripts/09-private-customizations.sh

install-gh-extensions: ##Private customizations
	@./scripts/10-install-gh-extensions.sh

customize-jupyter-env: ##Customizes Jupyter environment
	@./scripts/11-customize-jupyter-env.sh

1customize-apple-virtualization-configuration: ##Configures Apple Virtualization network configuration
	@./scripts/12-customize-apple-virtualization-configuration.sh

create-utm-arch-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@./scripts/30-create-utm-arch-linux-vm.sh

create-utm-ubuntu-linux-vm: ##Creates Arch Linux virtual machine in UTM
	@./scripts/30-create-utm-ubuntu-linux-vm.sh

dump-brew-packages: ##Dumps brew/mas packages into Brewfile
	@./scripts/99-dump-brew-packages.sh > ./Brewfile

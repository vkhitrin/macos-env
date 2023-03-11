.DEFAULT all:
	@echo "Please use one of the following options: install, uninstall"

install:
	@./Setup/install.sh

uninstall:
	@./Setup/uninstall.sh

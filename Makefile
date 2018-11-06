.DEFAULT all:
	@echo "Please use one of the following options: install, uninstall"
install:
	@chmod +x ./Setup/install.sh
	@./Setup/install.sh
uninstall:
	@chmod +x ./Setup/uninstall.sh
	@./Setup/uninstall.sh

.DEFAULT all:
	@echo "Please use one of the following options: install, uninstall, bootstrap-lima, teardown-lima"

install:
	@./Setup/install.sh

uninstall:
	@./Setup/uninstall.sh

bootstrap-lima:
	@./Setup/lima/bootstrap.sh

teardown-lima:
	@./Setup/lima/teardown.sh

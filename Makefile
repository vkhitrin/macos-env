.DEFAULT all:
	@echo "Please use one of the following options: install, uninstall, bootstrap-lima, teardown-lima"

install:
	@./Setup/install.sh

uninstall:
	@./Setup/uninstall.sh

# bootstrap-lima-x86:
# 	@./Setup/lima/bootstrap_x86.sh

#bootstrap-lima-arm64:
#	@./Setup/lima/bootstrap_arm64.sh

# teardown-lima:
# 	@./Setup/lima/teardown.sh

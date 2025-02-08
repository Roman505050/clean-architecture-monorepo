PACKAGES = packages/infrastructure packages/application packages/domain 
APPS = apps/rest

ifeq ($(OS),Windows_NT)
SHELL = cmd.exe
# For Windows OS
define RUN_LIST
	@echo =============================
	@echo $(1) $(2)... 
	@echo =============================
	@for %%i in ($(3)) do ( \
		echo $(1) $(2): %%i... && \
		$(MAKE) -C "%%i" $(4) && ( \
			echo ---------------------------- & \
			echo [OK] %%i & \
			echo ---------------------------- \
		) || ( \
			echo ---------------------------- & \
			echo [FAILED] %%i & \
			echo ---------------------------- & \
			exit /b 1 \
		) \
	)
	@echo =============================
	@echo $(1) $(2) complete.
	@echo =============================
endef
else
# For Linux and MacOS
define RUN_LIST
	@echo "============================="
	@echo "$(1) $(2)..."
	@echo "============================="
	@for item in $(3); do \
		echo "$(1) $(2): $$item..."; \
		$(MAKE) -C $$item $(4) && ( \
			echo "----------------------------"; \
			echo "[OK] $$item"; \
			echo "----------------------------" \
		) || ( \
			echo "----------------------------"; \
			echo "[FAILED] $$item"; \
			echo "----------------------------"; \
			exit 1; \
		); \
	done
	@echo "============================="
	@echo "$(1) $(2) complete."
	@echo "============================="
endef
endif

define RUN_TARGET
	$(call RUN_LIST,$(1),packages,$(PACKAGES),$(2))
	$(call RUN_LIST,$(1),apps,$(APPS),$(2))
endef

install:
	$(call RUN_TARGET,Installing,install)

lint:
	$(call RUN_TARGET,Linting,lint)

format:
	$(call RUN_TARGET,Formatting,format)

clean:
	$(call RUN_TARGET,Cleaning,clean)

help:
	@echo "============================== Commands =================================="
	@echo "Note: If you run in root directory, it will run in all packages and apps"
	@echo "=========================================================================="
	@echo "install                      - install dependencies in all packages"
	@echo "clean                        - clean virtual env and build artifacts"
	@echo "format                       - format code with black and isort"
	@echo "lint                         - lint code with flake8 and mypy"
	@echo "help                         - show this help message"
	@echo "=========================================================================="
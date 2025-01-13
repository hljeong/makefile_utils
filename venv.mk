VENV_DIR = .venv
VENV_ACTIVATE = activate
VENV_REQUIREMENTS = requirements.txt

.PHONY: venv-active venv-create venv-clean venv-force-install-deps venv-install-deps venv-setup venv-venv-dir-defined venv-venv-activate-defined venv-venv-requirements-defined venv-python-defined

venv-python-defined:
	@ [ -n '$(PYTHON)' ] || (echo 'PYTHON not specified in makefile'; exit 1)

venv-venv-dir-defined:
	@ [ -n '$(VENV_DIR)' ] || (echo 'VENV_DIR not specified in makefile'; exit 1)

venv-venv-activate-defined:
	@ [ -n '$(VENV_ACTIVATE)' ] || (echo 'VENV_ACTIVATE not specified in makefile'; exit 1)

venv-venv-requirements-defined:
	@ [ -n '$(VENV_REQUIREMENTS)' ] || (echo 'VENV_REQUIREMENTS not specified in makefile'; exit 1)

venv-active: venv-venv-activate-defined
	@ [ -n "$$VIRTUAL_ENV" ] || (echo 'venv not active, run: cd $(CURDIR); source ./$(VENV_ACTIVATE); cd -'; exit 1)

venv-create: 
	@ echo 'make venv-install-deps && . ./$(VENV_DIR)/bin/activate' >./$(VENV_ACTIVATE)
	@ [ -d ./$(VENV_DIR) ] || $(PYTHON) -m venv ./$(VENV_DIR)

venv-clean: venv-venv-dir-defined
	@ [ -z "$$VIRTUAL_ENV" ] || (echo 'venv is active, run: deactivate'; exit 1)
	@ rm -rf $(VENV_DIR)

venv-force-install-deps: venv-create venv-venv-requirements-defined
	@ \
	. ./$(VENV_DIR)/bin/activate && ( \
		if [ -f './$(VENV_REQUIREMENTS)' ]; then \
			python -m pip install -r ./$(VENV_REQUIREMENTS) && md5sum './$(VENV_REQUIREMENTS)' >./$(VENV_DIR)/requirements.md5; \
		fi \
	)

venv-install-deps: venv-create venv-venv-requirements-defined
	@ \
	. ./$(VENV_DIR)/bin/activate && ( \
		if [ -f './$(VENV_REQUIREMENTS)' ]; then \
			[ -f './$(VENV_DIR)/requirements.md5' ] && [ -n $$(md5sum './$(VENV_REQUIREMENTS)' | diff - ./$(VENV_DIR)/requirements.md5) ] || make venv-force-install-deps; \
		fi \
	)

venv-setup: venv-clean venv-venv-dir-defined venv-venv-activate-defined venv-python-defined
	@ echo 'setting up venv...' && make venv-install-deps && echo "done setting up venv"
	@ # venv-setup is supposed to be a top level target called by user only, so
	@ # it is assumed we are already in $(CURDIR)
	@ echo 'to activate venv, run: source $(VENV_ACTIVATE)'

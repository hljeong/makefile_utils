VENV_DIR = .venv
VENV_ACTIVATE = activate
VENV_REQUIREMENTS = requirements.txt

.PHONY: venv-active venv-create venv-clean venv-install-deps venv-list-deps venv-setup venv-venv-dir-defined venv-venv-activate-defined venv-venv-requirements-defined venv-python-defined

venv-python-defined:
	@ [ -n '$(PYTHON)' ] || (echo 'PYTHON not specified in makefile'; exit 1)

venv-venv-dir-defined:
	@ [ -n '$(VENV_DIR)' ] || (echo 'VENV_DIR not specified in makefile'; exit 1)

venv-venv-activate-defined:
	@ [ -n '$(VENV_ACTIVATE)' ] || (echo 'VENV_ACTIVATE not specified in makefile'; exit 1)

venv-venv-requirements-defined:
	@ [ -n '$(VENV_REQUIREMENTS)' ] || (echo 'VENV_REQUIREMENTS not specified in makefile'; exit 1)

venv-active:
	@ [ -n "$$VIRTUAL_ENV" ] || (echo 'venv not active: run: source activate'; exit 1)

venv-create: 
	@ echo 'make venv-install-deps && source ./$(VENV_DIR)/bin/activate' >./$(VENV_ACTIVATE)
	@ [ -d ./$(VENV_DIR) ] || $(PYTHON) -m venv ./$(VENV_DIR)

venv-clean: venv-venv-dir-defined
	@ [ -z "$$VIRTUAL_ENV" ] || (echo 'venv is active, run: deactivate'; exit 1)
	@ rm -rf $(VENV_DIR)

venv-install-deps: venv-create venv-venv-requirements-defined
	@ . ./$(VENV_DIR)/bin/activate && python -m pip install -r $(VENV_REQUIREMENTS)

venv-list-deps: venv-create venv-venv-requirements-defined
	@ . ./$(VENV_DIR)/bin/activate && python -m pip freeze >$(VENV_REQUIREMENTS)

venv-setup: venv-venv-dir-defined venv-venv-activate-defined venv-python-defined
	@ echo -n 'setting up venv...' && make venv-install-deps && echo "done"
	@ echo 'to activate venv, run: source activate'

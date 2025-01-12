.PHONY: python-clean python-python-defined

python-clean:
	$(PYTHON) -Bc "import pathlib; [p.unlink() for p in pathlib.Path('.').rglob('*.py[co]')]"  # delete .pyc and .pyo files
	$(PYTHON) -Bc "import pathlib; [p.rmdir() for p in pathlib.Path('.').rglob('__pycache__')]"  # delete __pycache__ directories

python-python-defined:
	@ [ -n '$(PYTHON)' ] || (echo 'PYTHON not specified in makefile'; exit 1)

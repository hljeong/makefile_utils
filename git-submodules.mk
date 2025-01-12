.PHONY: git-submodule-update

git-submodule-update:
	git subodule foreach 'git pull origin main && git submodule update --init'

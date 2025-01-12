GIT_HOOKS_DIR = .git-hooks

.PHONY: git-hooks-apply git-submodule-update git-submodule-reset

# todo: report if GIT_HOOKS_DIR does not exist or there are no hooks to be applied
git-hooks-apply:
	@ [ -n '$(GIT_HOOKS_DIR)' ] || (echo 'GIT_HOOKS_DIR not specified in makefile'; exit 1)
	@ \
	for hook in $(notdir $(wildcard ./$(GIT_HOOKS_DIR)/*)); do \
		if [ -d ".git/hooks/$$hook" ]; then \
			echo "cannot apply hook for $$hook: .git/hooks/$$hook is a directory"; \
			exit 1; \
		fi; \
		\
		if [ -f ".git/hooks/$$hook" ] || [ -L ".git/hooks/$$hook" ]; then \
			echo "replacing existing hook: $$hook"; \
			rm ".git/hooks/$$hook"; \
		else \
			echo "applying hook: $$hook"; \
		fi; \
		\
		ln -s "../../$(GIT_HOOKS_DIR)/$$hook" ".git/hooks/$$hook"; \
	done

git-submodule-update:
	@ git submodule foreach 'git pull --rebase origin main && git submodule update --init'

git-submodule-reset:
	@ git submodule deinit --all --force && git submodule update --init --recursive

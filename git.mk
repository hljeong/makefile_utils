GIT_HOOK_DIR = .git-hooks

.PHONY: git-hook-apply git-hook-git-hook-dir-defined git-submodule-update git-submodule-reset

git-hook-git-hook-dir-defined:
	@ [ -n '$(GIT_HOOK_DIR)' ] || (echo 'GIT_HOOK_DIR not specified in makefile'; exit 1)

git-hook-apply:
	@ [ -d './$(GIT_HOOK_DIR)' ] || (echo './$(GIT_HOOK_DIR) does not exist, no git hooks will be installed')
	@ \
	[ -n "$$(ls -A ./$(GIT_HOOK_DIR))" ] || (echo './$(GIT_HOOK_DIR) is empty, no git hooks will be installed'); \
	for hook in $(notdir $(wildcard ./$(GIT_HOOK_DIR)/*)); do \
		if [ -d "./$(GIT_HOOK_DIR)/$$hook" ]; then \
			echo "cannot apply git hook for $$hook: ./$(GIT_HOOK_DIR)/$$hook is a directory"; \
			exit 1; \
		fi; \
		\
		if [ ! -x "./$(GIT_HOOK_DIR)/$$hook" ]; then \
			echo "cannot apply git hook for $$hook: ./$(GIT_HOOK_DIR)/$$hook is not executable"; \
			exit 1; \
		fi; \
		\
		if [ -d ".git/hooks/$$hook" ]; then \
			echo "cannot apply git hook for $$hook: .git/hooks/$$hook is a directory"; \
			exit 1; \
		fi; \
		\
		if [ -f ".git/hooks/$$hook" ] || [ -L ".git/hooks/$$hook" ]; then \
			echo "replacing existing git hook: $$hook"; \
			rm ".git/hooks/$$hook"; \
		else \
			echo "applying git hook: $$hook"; \
		fi; \
		\
		ln -s "../../$(GIT_HOOK_DIR)/$$hook" ".git/hooks/$$hook"; \
	done

git-submodule-update:
	@ git submodule foreach 'git pull --rebase origin main && git submodule update --init'

git-submodule-reset:
	@ git submodule deinit --all --force && git submodule update --init --recursive

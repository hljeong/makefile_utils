GIT_HOOKS_DIR = .git-hooks

.PHONY: git-hooks-apply git-submodule-update

git-hooks-apply:
	@[ -n '$(GIT_HOOKS_DIR)' ] || (echo 'GIT_HOOKS_DIR not specified in makefile'; exit 1)
	@for hook in $(notdir $(wildcard ./$(GIT_HOOKS_DIR)/*)); do \
		echo "replacing existing hook: $$hook" && \
		rm -f ".git/hooks/$$hook" && \
		ln -s "../../$(GIT_HOOKS_DIR)/$$hook" ".git/hooks/$$hook"; \
	done

git-submodule-update:
	git submodule foreach 'git pull origin main && git submodule update --init'

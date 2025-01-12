GITHOOKS_DIR = .githooks

.PHONY: githooks

githooks:
	@[ -n '$(GITHOOKS_DIR)' ] || (echo 'GITHOOKS_DIR not specified in makefile'; exit 1)
	@for hook in $(notdir $(wildcard ./$(GITHOOKS_DIR)/*)); do \
		echo "replacing existing hook: $$hook" && \
		rm -f ".git/hooks/$$hook" && \
		ln -s "../../$(GITHOOKS_DIR)/$$hook" ".git/hooks/$$hook"; \
	done

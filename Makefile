BIN_DIR=/usr/local/bin
OUTPUT_PATH=$(shell pwd)/build/.less-git-log

ifeq ($(shell uname), Darwin)
	PASTE_COMMAND=pbpaste
else
	PASTE_COMMAND=xsel -o
endif

install: link-scripts set-lesskey
.PHONY: install

set-lesskey: clean-lesskey
	mkdir build

	sed 's/{{PASTE_COMMAND}}/$(PASTE_COMMAND)/g' ./src/git-log.lesskey | lesskey -o $(OUTPUT_PATH) -

	git config --global pager.log "less --lesskey-file=$(OUTPUT_PATH) --chop-long-lines --ignore-case --LONG-PROMPT --LINE-NUMBERS --RAW-CONTROL-CHARS --status-column --tilde"
.PHONY: set-lesskey

clean-lesskey:
	rm -rf ./build

	git config --global --unset pager.log 2>/dev/null || :
.PHONY: clean-lesskey

link-scripts: clean-scripts
	sudo ln -s $(shell pwd)/src/git-log-tools.sh $(BIN_DIR)/git-log-tools
	sudo chmod 755 $(BIN_DIR)/git-log-tools

	sudo ln -s $(shell pwd)/src/less-git-tools.sh $(BIN_DIR)/less-git-tools
	sudo chmod 755 $(BIN_DIR)/less-git-tools
.PHONY: link-scripts

clean-scripts:
	sudo rm $(BIN_DIR)/git-log-tools 2>/dev/null || :
	sudo rm $(BIN_DIR)/less-git-tools 2>/dev/null || :
.PHONY: clean-scripts

clean: clean-scripts clean-lesskey
.PHONY: clean

uninstall: clean
.PHONY: uninstall

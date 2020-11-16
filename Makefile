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

	git config --global --unset pager.log || :
.PHONY: clean-lesskey

link-scripts: clean-scripts
	ln -s $(shell pwd)/src/git-log-tools.sh /usr/local/bin/git-log-tools
	chmod -h 755 /usr/local/bin/git-log-tools

	ln -s $(shell pwd)/src/less-git-tools.sh /usr/local/bin/less-git-tools
	chmod -h 755 /usr/local/bin/less-git-tools
.PHONY: link-scripts

clean-scripts:
	rm /usr/local/bin/git-log-tools || :
	rm /usr/local/bin/less-git-tools || :
.PHONY: clean-scripts

clean: clean-scripts clean-lesskey
.PHONY: clean

uninstall: clean
.PHONY: uninstall

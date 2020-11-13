#!/bin/bash

COMMAND="${1:?Command required}"
COMMIT="${2:?Commit hash required}"
ALT_COMMIT="${3}"

function _writeToLog() {
	if [ -f "${GIT_LOG_TOOLS_LOG_FILE}" ]
	then
		echo "$1" >> "${GIT_LOG_TOOLS_LOG_FILE}"
	fi
}

function _log() {
	_writeToLog "[LOG] [$(date +"%D %r")] $1"
}

function _warn() {
	_writeToLog "[WARN] [$(date +"%D %r")] $1"
}

function _logAndExecute() {
	_log "Executing command: $*"
	"$@"
}

# Given two git commit hashes, this function will output in range format, with the
# ancestor commit coming first. If only one commit is given, then use a
# "single commit range"

function hashRange() {
	if [ -z "$2" ]
	then
		echo "$1^..$1"
		exit
	fi

	if git merge-base --is-ancestor "$1" "$2"
	then
		echo "$1^..$2"
	else
		echo "$2^..$1"
	fi
}

function getRange() {
	hashRange "${COMMIT}" "${ALT_COMMIT}"
}

if [ -z "${COMMAND}" ]
then
	echo "Command required as first positional argument"
	exit 1

elif [ "${COMMAND}" = "cherry-pick" ]
then
	_logAndExecute git cherry-pick "$(getRange)" || git cherry-pick --abort && _warn "Cherry-pick aborted"

elif [ "${COMMAND}" = "diff" ]
then
	_logAndExecute git diff "$(getRange)" --patch --stat-width=1000 --ignore-all-space

elif [ "${COMMAND}" = "difftool" ]
then
	_logAndExecute git difftool "$(getRange)"

elif [ "${COMMAND}" = "files" ]
then
	_logAndExecute git --paginate diff "$(getRange)" --name-only

elif [ "${COMMAND}" = "format-patch" ]
then
	if [ ! -d "$GIT_LOG_TOOLS_PATCH_DIR" ]
	then
		echo "Please set the 'GIT_LOG_TOOLS_PATCH_DIR' environment variable to a directory path. The patch files will be placed there."

		exit 1
	fi
	_logAndExecute git format-patch -o "${GIT_LOG_TOOLS_PTACH_DIR}" "$(getRange)"

elif [ "${COMMAND}" = "fixup" ]
then
	_logAndExecute git commit --fixup="${COMMIT}"

elif [ "${COMMAND}" = "open" ]
then
	_log "Opening files with command: $(git diff "$(getRange)" --name-only | head -n "${GIT_LOG_TOOLS_FILE_OPEN_LIMIT:-50}")"
	for file in $(git diff "$(getRange)" --name-only | head -n "${GIT_LOG_TOOLS_FILE_OPEN_LIMIT:-50}")
	do
		open "$file" 2>/dev/null || echo "Could not open file: $file"
	done

elif [ "${COMMAND}" = "rebase" ]
then
	_logAndExecute git rebase --autosquash --interactive "${COMMIT}^" || git rebase --abort && _warn "Rebase aborted"

elif [ "${COMMAND}" = "revert" ]
then
	_logAndExecute git revert "$(getRange)"

elif [ "${COMMAND}" = "show" ]
then
	_logAndExecute git show --color=always "${COMMIT}"

elif [ "${COMMAND}" = "yank" ]
then
	_log "Executing command: printf \"%s\" \"${COMMIT}\" | pbcopy"

	printf "%s" "${COMMIT}" | pbcopy


###
### BEGIN	These depend on my personal scripts
###

elif [ "${COMMAND}" = "issue" ] && command -v ji 2>/dev/null
then
	_logAndExecute ji "$(git show --no-patch --pretty="format:%s" "${COMMIT}")"

elif [ "${COMMAND}" = "modules" ] && [ -f "$HOME/Documents/sed_commands/show_modules.txt" ]
then
	git diff "$(getRange)" --name-only |
	sed -f "$HOME/Documents/sed_commands/show_modules.txt" |
	sort -u |
	less

elif [ "${COMMAND}" = "pull-request" ] && command -v getpr 2>/dev/null
then
	_logAndExecute getpr "$(git show --no-patch --pretty="format:%s" "${COMMIT}")"

###
### END		These depend on my personal scripts
###


# Really only for debugging purposes
elif [ "${COMMAND}" = "print" ]
then
	echo "COMMIT:		${COMMIT}"
	echo "ALT_COMMIT:	${ALT_COMMIT}"
	echo "RANGE:		$(getRange)"

else
	echo "Unknown command: ${COMMAND}" | less
	exit 1

fi

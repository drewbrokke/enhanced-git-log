#!/bin/bash

# set -x
COMMIT=""
while read -r line
do
	SHA="$(
		echo "${line}" |
		sed $'s,\x1b\\[[0-9;]*[a-zA-Z],,g' |
		grep --extended-regexp --only-matching '\b[0-9a-f]{7,40}\b' 2>/dev/null |
		head -n 1
	)"

	# If the "SHA" read from the stdin isn't a commit hash,
	# try the next line
	git cat-file -t "${SHA}" &>/dev/null || continue;

	COMMIT="${SHA}"

	break
done < /dev/stdin
# set +x

[ -z "${COMMIT}" ] && exit 1

COMMAND="${1}"

ALT_COMMIT="${2}"

git log-tools "${COMMAND}" "${COMMIT}" "${ALT_COMMIT}"

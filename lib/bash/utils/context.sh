#!/usr/bin/env bash
# this file is meant to be sourced by a bash script, running it will do nothing.
# the shebang here is strictly to provide convenient indication to your editor
# for highlighting, completion, etc.

# Sourcing this file provides the following environment variables:
#   LIB_PATH -> Path to script library
#   IS_DEVBOX     -> 'true' if on devbox, 'false' otherwise
#   IS_LAPTOP     -> 'true' if on laptop, 'false' otherwise
#   CTX_SET       -> set if context has been sourced, unset if not

# only set context once
if [[ -z ${SCRIPT_CONTEXTS_SET+x} ]]; then
	LIB_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}/")/.." && pwd -P)"
	IS_LINUX="$([[ $(uname) == 'Linux' ]] && echo 'true' || echo "false")"
	IS_MAC="$([[ $(uname) == 'Darwin' ]] && echo 'true' || echo "false")"
	CTX_SET="TRUE"
	export LIB_PATH
	export IS_LINUX
	export IS_MAC
	export CTX_SET
fi

get_absolute_source_path() {
	printf '%s' "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
}

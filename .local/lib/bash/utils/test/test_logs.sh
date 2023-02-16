#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
. "$HOME/lib/bash/utils/test/safety_checks.sh"

# we don't test log::fatal as IFS side effects won't matter.
test::safety::no_IFS_side_effects \
	"log::debug" \
	"log::error" \
	"log::info" \
	"log::warn" \
	"log::test::failure" \
	"log::test::success"

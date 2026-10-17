#!/usr/bin/env bash
# checkout.sh REF [all]: syg-core at REF (a branch, tag or commit) into core/:
# the commit alone, or with "all" its history and tags too (for git describe).
# Quietly: git's detached-HEAD message would print the commit's subject.
set -euo pipefail
ref=${1:?usage: checkout.sh REF [all]}
. "$(dirname "$0")/lib.sh"
fetch=(--depth 1 --no-tags)
if [ "${2:-}" = all ]; then fetch=(--tags); fi
git -c init.defaultBranch=main init -q core
core_git -C core fetch -q "${fetch[@]}" "$CORE_URL" "$ref"
git -C core -c advice.detachedHead=false checkout -q FETCH_HEAD

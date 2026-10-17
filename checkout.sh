#!/usr/bin/env bash
# checkout.sh REF: syg-core at REF (a branch, tag or commit) into core/.
# Quietly: git's detached-HEAD message would print the commit's subject. The
# token is used for this fetch alone, and not kept.
set -euo pipefail
ref=${1:?usage: checkout.sh REF}
: "${CORE_READ_TOKEN:?the CORE_READ_TOKEN secret is not set}"
basic=$(printf 'x-access-token:%s' "$CORE_READ_TOKEN" | base64 | tr -d '\n')
echo "::add-mask::$basic"
git -c init.defaultBranch=main init -q core
git -C core -c "http.extraheader=AUTHORIZATION: basic $basic" \
  fetch -q --depth 1 --no-tags https://github.com/Vishisht16/Syg-Core.git "$ref"
git -C core -c advice.detachedHead=false checkout -q FETCH_HEAD

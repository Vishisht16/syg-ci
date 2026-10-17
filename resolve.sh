#!/usr/bin/env bash
# resolve.sh REF: the commit a run tests, so that a push during the run changes
# nothing. Checks syg-core out at REF, sets the commit status "syg-ci" there to
# pending, and writes the job's outputs: sha; default, whether it is the
# default branch's head; and pages, whether this repository's Pages deploys
# from GitHub Actions (then the default branch's site is the preview).
set -euo pipefail
here=$(dirname "$0")
bash "$here/checkout.sh" "${1:?usage: resolve.sh REF}"
. "$here/lib.sh"
sha=$(git -C core rev-parse HEAD)
head=$(core_git ls-remote "$CORE_URL" HEAD | cut -f1)
default=false
if [ "$sha" = "$head" ]; then default=true; fi
pages=false
if [ "$(gh api "repos/$GITHUB_REPOSITORY/pages" --jq .build_type 2>/dev/null)" = workflow ]; then pages=true; fi
echo "testing $sha (the default branch's head: $default; the preview deploys: $pages)"
{ echo "sha=$sha"; echo "default=$default"; echo "pages=$pages"; } >> "$GITHUB_OUTPUT"
bash "$here/status.sh" "$sha" pending

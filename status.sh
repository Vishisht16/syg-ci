#!/usr/bin/env bash
# status.sh SHA pending | status.sh SHA NEEDS: sets the commit status "syg-ci"
# on SHA in syg-core, linking this run; a pull request there shows it. NEEDS is
# the jobs' results, toJSON(needs): success when every job passed or was
# skipped, failure when one failed, error when one was cancelled. Without
# "Commit statuses: read and write" on syg-core, the token earns a warning.
set -euo pipefail
sha=${1:?usage: status.sh SHA pending|NEEDS}
. "$(dirname "$0")/lib.sh"
if [ "${2:?usage: status.sh SHA pending|NEEDS}" = pending ]; then
  state=pending desc="running"
else
  failed=$(jq -r '[to_entries[] | select(.value.result == "failure") | .key] | join(", ")' <<< "$2")
  cancelled=$(jq -r '[to_entries[] | select(.value.result == "cancelled") | .key] | join(", ")' <<< "$2")
  if [ -n "$failed" ]; then state=failure desc="failed: $failed"
  elif [ -n "$cancelled" ]; then state=error desc="cancelled: $cancelled"
  else state=success desc="every job passed"
  fi
fi
body=$(jq -n --arg state "$state" --arg desc "$desc" \
  --arg url "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID" \
  '{state: $state, description: $desc, target_url: $url, context: "syg-ci"}')
if core_api -X POST "https://api.github.com/repos/$CORE/statuses/$sha" -d "$body" > /dev/null; then
  echo "syg-ci: $state ($desc)"
else
  echo "::warning::the commit status was not set: the token needs Commit statuses: read and write on syg-core"
fi

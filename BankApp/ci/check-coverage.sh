#!/usr/bin/env bash
# Checks BankApp.app line coverage from one or more .xcresult bundles.
# Multiple bundles are merged (unit + UI) so UI runs count toward coverage.
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: check-coverage.sh <TestResults.xcresult> [more bundles...]" >&2
  exit 1
fi

THRESHOLD="${COVERAGE_THRESHOLD:-70"}
JSON="$(mktemp)"
MERGED_BUNDLE=""

trap 'rm -f "$JSON"; [ -n "$MERGED_BUNDLE" ] && rm -rf "$MERGED_BUNDLE"' EXIT

if [ "$#" -eq 1 ]; then
  RESULT_BUNDLE="$1"
else
  MERGED_BUNDLE="TestResults-Merged.xcresult"
  rm -rf "$MERGED_BUNDLE"
  echo "Merging $# result bundles into ${MERGED_BUNDLE} ..."
  xcrun xcresulttool merge "$@" --output-path "$MERGED_BUNDLE"
  RESULT_BUNDLE="$MERGED_BUNDLE"
fi

xcrun xccov view --report --json "$RESULT_BUNDLE" > "$JSON"

COVERAGE="$(python3 - "$JSON" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    data = json.load(handle)

for target in data.get("targets", []):
    name = target.get("name", "")
    if name == "BankApp.app" or name.endswith("BankApp.app"):
        line_coverage = target.get("lineCoverage")
        if line_coverage is None:
            break
        print(f"{float(line_coverage) * 100:.2f}")
        sys.exit(0)

sys.exit(2)
PY
)" || {
  echo "Failed to read line coverage for BankApp.app from $RESULT_BUNDLE"
  xcrun xccov view --report "$RESULT_BUNDLE" || true
  exit 1
}

echo "BankApp line coverage: ${COVERAGE}% (required >= ${THRESHOLD}%, sources: $*)"

python3 - <<PY "$COVERAGE" "$THRESHOLD"
import sys

coverage = float(sys.argv[1])
threshold = float(sys.argv[2])
if coverage + 1e-9 < threshold:
    print(f"Coverage {coverage:.2f}% is below {threshold:.0f}%", file=sys.stderr)
    sys.exit(1)
PY

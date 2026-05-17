#!/usr/bin/env bash
set -euo pipefail

RESULT_BUNDLE="${1:?Usage: check-coverage.sh <TestResults.xcresult>}"
THRESHOLD="${COVERAGE_THRESHOLD:-90}"
JSON="$(mktemp)"

trap 'rm -f "$JSON"' EXIT

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

echo "BankApp line coverage: ${COVERAGE}% (required >= ${THRESHOLD}%)"

python3 - <<PY "$COVERAGE" "$THRESHOLD"
import sys

coverage = float(sys.argv[1])
threshold = float(sys.argv[2])
if coverage + 1e-9 < threshold:
    print(f"Coverage {coverage:.2f}% is below {threshold:.0f}%", file=sys.stderr)
    sys.exit(1)
PY

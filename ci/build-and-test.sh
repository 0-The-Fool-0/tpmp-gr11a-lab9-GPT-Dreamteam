#!/usr/bin/env bash
# Локальный сценарий CI: тесты → проверка coverage → сборка (как в GitHub Actions)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

PROJECT="BankApp.xcodeproj"
SCHEME="BankApp"
TEST_PLAN="BankApp"
DEVICE="${SIMULATOR_DEVICE:-iPhone 16}"
DESTINATION="platform=iOS Simulator,name=${DEVICE}"

echo "=== 1/4 Unit tests (Test Plan: Unit Tests) ==="
rm -rf TestResults-Unit.xcresult
xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -testPlan "$TEST_PLAN" \
  -only-test-configuration "Unit Tests" \
  -only-testing:BankAppTests \
  -destination "${DESTINATION}" \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  -enableCodeCoverage YES \
  -parallel-testing-enabled NO \
  -maximum-parallel-testing-workers 1 \
  -resultBundlePath TestResults-Unit.xcresult

echo "=== 2/4 Coverage check (>= ${COVERAGE_THRESHOLD:-90}%) ==="
./ci/check-coverage.sh TestResults-Unit.xcresult

echo "=== 3/4 UI tests (Test Plan: UI Tests) ==="
rm -rf TestResults-UI.xcresult
xcodebuild test \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -testPlan "$TEST_PLAN" \
  -only-test-configuration "UI Tests" \
  -only-testing:BankAppUITests \
  -destination "${DESTINATION}" \
  -configuration Debug \
  CODE_SIGNING_ALLOWED=NO \
  -resultBundlePath TestResults-UI.xcresult

echo "=== 4/4 Release build (only after tests passed) ==="
xcodebuild build \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -destination "${DESTINATION}" \
  -configuration Release \
  CODE_SIGNING_ALLOWED=NO

echo "All steps completed successfully."

#!/usr/bin/env bash
# Master pre-release gate for FAAH.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=== Pre-release Validation Gates ==="

# 1. Integrity check
"${SCRIPT_DIR}/check-plugin-integrity.sh"

# 2. Release metadata checks
echo "--- Metadata Checks ---"

if [ ! -f "${PLUGIN_ROOT}/VERSION" ]; then
    echo "❌ Error: VERSION file is missing."
    exit 1
fi
VERSION=$(cat "${PLUGIN_ROOT}/VERSION")
echo "✅ VERSION found: $VERSION"

if [ ! -f "${PLUGIN_ROOT}/LICENSE" ]; then
    echo "❌ Error: LICENSE file is missing."
    exit 1
fi
echo "✅ LICENSE found."

if [ ! -f "${PLUGIN_ROOT}/CHANGELOG.md" ]; then
    echo "❌ Error: CHANGELOG.md is missing."
    exit 1
fi
echo "✅ CHANGELOG.md found."

# 3. Manifest version sync check
MANIFEST_VERSION=$(grep '"version":' "${PLUGIN_ROOT}/.claude-plugin/plugin.json" | cut -d'"' -f4)
if [ "$VERSION" != "$MANIFEST_VERSION" ]; then
    echo "❌ Error: Version mismatch! VERSION file says '$VERSION' but plugin.json says '$MANIFEST_VERSION'."
    exit 1
fi
echo "✅ VERSION and plugin.json versions match."

echo "=== All Release Checks Passed! ==="
exit 0

#!/usr/bin/env bash
# Validates plugin integrity: folders, skills, and manifest consistency.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
PLUGIN_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "--- Plugin Integrity Check ---"

# 1. Check skills directory
if [ ! -d "${PLUGIN_ROOT}/skills" ]; then
    echo "❌ Error: skills/ directory not found."
    exit 1
fi

# 2. Validate each skill folder
errors=0
for skill_dir in "${PLUGIN_ROOT}/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    skill_md="${skill_dir}SKILL.md"

    # Check for SKILL.md
    if [ ! -f "$skill_md" ]; then
        echo "❌ Error: Skill '$skill_name' is missing SKILL.md"
        errors=$((errors + 1))
        continue
    fi

    # Check frontmatter name matches folder name
    fm_name=$(grep "^name:" "$skill_md" | head -n 1 | cut -d':' -f2- | xargs)
    if [ "$fm_name" != "$skill_name" ]; then
        echo "❌ Error: Skill '$skill_name' has mismatched name in frontmatter: '$fm_name'"
        errors=$((errors + 1))
    fi

    # Check description exists
    if ! grep -q "^description:" "$skill_md"; then
        echo "❌ Error: Skill '$skill_name' is missing description in frontmatter"
        errors=$((errors + 1))
    fi
done

if [ "$errors" -eq 0 ]; then
    echo "✅ All skills validated (folder names match frontmatter, SKILL.md exists)."
else
    echo "❌ Total errors found: $errors"
    exit 1
fi

# 3. Check commands
if [ ! -d "${PLUGIN_ROOT}/commands" ]; then
    echo "⚠️  Warning: commands/ directory not found."
else
    echo "✅ Commands directory found."
fi

# 4. Check manifest
if [ ! -f "${PLUGIN_ROOT}/.claude-plugin/plugin.json" ]; then
    echo "❌ Error: plugin.json not found."
    exit 1
else
    echo "✅ plugin.json found."
fi

echo "--- Integrity Check Passed ---"
exit 0

#!/usr/bin/env bash

# Function to derive project key from path
# Rules:
# 1. Replace Windows backslashes with forward slashes
# 2. Strip leading slash
# 3. Replace remaining slashes with hyphens
# 4. Convert to lowercase
derive_project_key() {
    local input_path="$1"
    
    # Normalize path (replace \ with /)
    local normalized="${input_path//\\//}"
    
    # Strip leading slash
    local stripped="${normalized#/}"
    
    # Replace slashes with hyphens
    local with_hyphens="${stripped//\//-}"
    
    # Lowercase (using tr for cross-platform support)
    echo "$with_hyphens" | tr '[:upper:]' '[:lower:]'
}

#!/bin/bash
# Spec-Kit Setup Helper Script
# This script helps initialize spec-kit with proper GitHub token configuration

set -e

echo "========================================"
echo "  Spec-Kit Initialization Helper"
echo "========================================"
echo ""

# Check if uv is installed
if ! command -v uv &> /dev/null; then
    echo "Error: uv is not installed"
    echo "Install it with: pip install uv"
    exit 1
fi

echo "✓ uv is installed ($(uv --version))"
echo ""

# Check for GitHub token
if [ -z "$GITHUB_TOKEN" ] && [ -z "$GH_TOKEN" ]; then
    echo "⚠️  No GitHub token found in environment"
    echo ""
    echo "A GitHub Personal Access Token is required to avoid rate limiting."
    echo ""
    echo "To create a token:"
    echo "  1. Go to: https://github.com/settings/tokens"
    echo "  2. Click 'Generate new token (classic)'"
    echo "  3. No scopes needed for public repo access"
    echo "  4. Copy the generated token"
    echo ""
    read -p "Enter your GitHub token (or press Enter to skip): " token
    
    if [ -n "$token" ]; then
        export GITHUB_TOKEN="$token"
        echo "✓ GitHub token set for this session"
        echo ""
        echo "To make this permanent, add to your ~/.bashrc or ~/.zshrc:"
        echo "  export GITHUB_TOKEN=$token"
        echo ""
    else
        echo ""
        echo "⚠️  Proceeding without token - may encounter rate limits"
        echo ""
        read -p "Continue anyway? (y/N): " continue
        if [ "$continue" != "y" ] && [ "$continue" != "Y" ]; then
            echo "Aborted."
            exit 1
        fi
    fi
else
    echo "✓ GitHub token found in environment"
fi

echo ""
echo "Starting spec-kit initialization..."
echo ""
echo "When prompted, select:"
echo "  - AI Assistant: copilot"
echo "  - Script Type: sh"
echo ""
read -p "Press Enter to continue..."

# Run spec-kit initialization
uvx --from git+https://github.com/github/spec-kit.git specify init --here

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "========================================"

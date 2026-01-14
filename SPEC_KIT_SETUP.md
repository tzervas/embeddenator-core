# GitHub Spec-Kit Setup

## Overview

This document describes the GitHub Spec-Kit setup for the embeddenator-core repository.

## Current Status

- **uv** package manager has been installed (version 0.9.25)
- The repository content has been migrated from the embeddenator dev branch
- Spec-kit initialization requires a GitHub token due to API rate limits (60/hr without auth, 5000/hr with auth)
- **Note**: The current GitHub Actions environment does not have GITHUB_TOKEN available to this process

## Solution: Two Approaches

### Approach 1: Manual Setup (Recommended for Now)

Since the GITHUB_TOKEN is not available in the current execution context, manual setup is recommended:

1. **Create a GitHub Personal Access Token** (see instructions below)
2. **Add it as a repository secret** named `SPEC_KIT_TOKEN`
3. **Run the setup script** either locally or in a workflow that passes the token

### Approach 2: GitHub Actions Workflow (Future)

Create a workflow that properly passes the GITHUB_TOKEN to the spec-kit initialization step.

## Prerequisites: GitHub Token

### Creating a GitHub Personal Access Token

1. Go to GitHub Settings → Developer settings → [Personal access tokens (classic)](https://github.com/settings/tokens)
2. Click "Generate new token" → "Generate new token (classic)"
3. Name: `spec-kit-initialization`
4. **No special scopes needed** - leave all checkboxes unchecked for read-only public access
5. Set expiration: 30 days (or as desired)
6. Click "Generate token"
7. **Copy the token immediately** - you won't be able to see it again!

### Option A: Add as Repository Secret (For CI/CD)

1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `SPEC_KIT_TOKEN`
4. Value: paste your token
5. Click "Add secret"

### Option B: Set in Local Environment

```bash
# Set the token in your current session
export GITHUB_TOKEN=ghp_your_token_here

# OR use GH_TOKEN (both work)
export GH_TOKEN=ghp_your_token_here
```

To make the token persistent across sessions:

```bash
# For bash
echo 'export GITHUB_TOKEN=ghp_your_token_here' >> ~/.bashrc

# For zsh
echo 'export GITHUB_TOKEN=ghp_your_token_here' >> ~/.zshrc
```

## Completing Spec-Kit Setup

Once you have set the GitHub token, run:

```bash
# Verify token is set
echo $GITHUB_TOKEN

# Run spec-kit initialization
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### Configuration Options

When prompted, use these settings:
- **AI Assistant**: `copilot` (GitHub Copilot)
- **Script Type**: `sh` (POSIX Shell for bash/zsh)

### Automated Setup Script

For convenience, you can use the provided setup script:

```bash
./scripts/setup-speckit.sh
```

This script will:
1. Check for a GitHub token
2. Prompt you to enter one if not found
3. Run the spec-kit initialization with proper configuration

### Persistent Installation

For persistent access to the specify CLI:

```bash
# Make sure GITHUB_TOKEN is set first
export GITHUB_TOKEN=ghp_your_token_here

# Install specify-cli
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

Then you can use:

```bash
specify init --here
```

### Rate Limit Information

- **Without token**: 60 requests/hour from your IP
- **With token**: 5,000 requests/hour
- Spec-kit initialization makes multiple API calls to GitHub
- Token is strongly recommended to avoid initialization failures

### Using in GitHub Actions

A workflow has been provided at `.github/workflows/init-speckit.yml` to demonstrate spec-kit initialization in CI/CD.

**To use it:**

1. Add a `SPEC_KIT_TOKEN` repository secret (instructions above)
2. Go to Actions tab → "Initialize Spec-Kit" workflow → "Run workflow"

**Note**: Spec-kit currently requires interactive input, so the workflow demonstrates the setup but cannot complete it fully. For now, local setup with a token is the recommended approach.

Example workflow usage:

```yaml
- name: Initialize Spec-Kit
  env:
    GITHUB_TOKEN: ${{ secrets.SPEC_KIT_TOKEN || secrets.GITHUB_TOKEN }}
  run: |
    uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

The `secrets.GITHUB_TOKEN` is automatically provided by GitHub Actions but may not have sufficient rate limits. Using a dedicated `SPEC_KIT_TOKEN` secret is recommended.

## Spec-Kit Commands

Once initialized, the following spec-kit commands will be available in your AI agent:

- `/speckit.specify` - Create specifications
- `/speckit.plan` - Generate implementation plans
- `/speckit.tasks` - Breakdown actionable tasks

## Directory Structure

After successful initialization, spec-kit will create a `.specify/` directory containing:
- Scripts for spec-driven development
- Templates for specifications
- Configuration files

## References

- [GitHub Spec-Kit Repository](https://github.com/github/spec-kit)
- [Spec-Kit Documentation](https://github.github.com/spec-kit/)
- [Installation Guide](https://github.github.com/spec-kit/installation.html)

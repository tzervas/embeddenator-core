# GitHub Spec-Kit Setup

## Overview

This document describes the GitHub Spec-Kit setup for the embeddenator-core repository.

## Current Status

- **uv** package manager has been installed (version 0.9.25)
- The repository content has been migrated from the embeddenator dev branch
- Spec-kit initialization was attempted but encountered API rate limits

## Completing Spec-Kit Setup

To complete the spec-kit initialization for this repository, run:

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### Configuration Options

When prompted, use these settings:
- **AI Assistant**: `copilot` (GitHub Copilot)
- **Script Type**: `sh` (POSIX Shell for bash/zsh)

### Alternative: Using GitHub Token

If you encounter rate limiting issues, provide a GitHub token:

```bash
# Set GitHub token environment variable
export GH_TOKEN=your_github_token_here

# Then run the init command
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

### Persistent Installation

For persistent access to the specify CLI:

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git
```

Then you can use:

```bash
specify init --here
```

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

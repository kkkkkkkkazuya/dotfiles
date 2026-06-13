# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files and setup scripts for macOS development environment. The repository follows a modular approach with configurations separated by tool/application.

## Setup Commands

### Initial Setup
```bash
# Install all dependencies and create symlinks
./bin/setup.sh
```

This script will:
1. Install Homebrew (if not present)
2. Install all packages from brew/Brewfile
3. Create symlinks for dotfiles
4. Run additional linking via bin/link.sh

### Manual Symlink Creation
```bash
# Create individual symlinks
./bin/link.sh
```

### Package Management
```bash
# Install packages from Brewfile
cd brew && brew bundle

# Add new packages to Brewfile
brew bundle dump --describe --force --file=./Brewfile
```

## Architecture and Code Organization

### Directory Structure
- `bin/` - Setup and utility scripts
- `brew/` - Homebrew package management
  - `Brewfile` - Complete package list including CLI tools, casks, and VS Code extensions
- `vscode/` - VS Code configuration
  - `settings.json` - Editor settings with vim integration and language-specific configs
  - `keybindings.json` - Custom key bindings
- `zsh/` - Zsh shell configuration
  - `.zshrc` - Main shell configuration with modular loading
- Root dotfiles: `.exports`, `.aliases`, `.functions` (referenced by .zshrc)

### Key Configuration Patterns

#### Modular Zsh Configuration
The .zshrc sources separate files for exports, aliases, and functions, allowing for organized configuration management.

#### Environment Management
- Uses anyenv for managing multiple language versions (Python, Go, Node.js, Terraform)
- Automatic installation of missing env managers on shell startup
- Secure environment variables loaded from ~/.secrets.sh

#### Development Tools Integration
- direnv for per-project environment variables
- PostgreSQL 16 with service management
- Docker and docker-compose for containerization
- AWS CLI with vault integration

#### VS Code Configuration
- Vim keybindings with 'jj' as escape sequence
- Go development with proper GOPATH/GOROOT configuration
- Multi-language support via extensions in Brewfile
- GitHub Copilot integration enabled

## Important Notes

- The setup scripts expect the repository to be cloned to ~/dotfiles
- Backup files are created automatically when linking (*.bak extension)
- The .zshrc includes `exec $SHELL -l` which restarts the shell after sourcing
- Secrets should be placed in ~/.secrets.sh (not tracked in repo)
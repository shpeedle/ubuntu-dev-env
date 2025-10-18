#!/bin/bash

# Visual Studio Code Installation Script
# Installs VSCode using Microsoft's official repository

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[VSCODE]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[VSCODE]${NC} $1"
}

# Check if VSCode is already installed
if command -v code &> /dev/null; then
    CURRENT_VERSION=$(code --version | head -n 1)
    log_warn "VSCode is already installed (version ${CURRENT_VERSION})"
    read -p "Do you want to reinstall VSCode? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping VSCode installation"
        exit 0
    fi
fi

log_info "Installing Visual Studio Code..."

# Install dependencies
sudo apt-get install -y wget gpg apt-transport-https

# Download and add Microsoft GPG key
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
rm packages.microsoft.gpg

# Add VSCode repository
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

# Update package lists
sudo apt-get update

# Install VSCode
sudo apt-get install -y code

# Verify installation
if command -v code &> /dev/null; then
    VSCODE_VERSION=$(code --version | head -n 1)
    log_info "VSCode installed successfully: ${VSCODE_VERSION}"

    # Install recommended extensions for development
    log_info "Installing recommended extensions..."

    # Python
    code --install-extension ms-python.python --force

    # Node.js/JavaScript
    code --install-extension dbaeumer.vscode-eslint --force

    # Go
    code --install-extension golang.go --force

    # Rust
    code --install-extension rust-lang.rust-analyzer --force

    # Git
    code --install-extension eamodio.gitlens --force

    # General
    code --install-extension EditorConfig.EditorConfig --force

    log_info "VSCode setup completed successfully"
else
    log_error "VSCode installation failed"
    exit 1
fi

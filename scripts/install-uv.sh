#!/bin/bash

# Astral UV Installation Script
# Installs uv - an extremely fast Python package installer and resolver

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[UV]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[UV]${NC} $1"
}

# Check if UV is already installed
if command -v uv &> /dev/null; then
    CURRENT_VERSION=$(uv --version)
    log_warn "UV is already installed (${CURRENT_VERSION})"
    read -p "Do you want to update UV? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Updating UV..."
        uv self update
        log_info "UV updated successfully"
    else
        log_info "Skipping UV installation"
    fi
    exit 0
fi

log_info "Installing Astral UV..."

# Install dependencies
log_info "Installing dependencies..."
sudo apt-get install -y curl

# Download and run the UV installer
log_info "Running UV installer..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Source the cargo/UV environment for current session
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Verify installation
if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version)
    log_info "UV installed successfully: ${UV_VERSION}"

    log_info "UV capabilities:"
    log_info "  - Extremely fast Python package installation"
    log_info "  - Drop-in replacement for pip, pip-tools, and virtualenv"
    log_info "  - Project and script management"
    log_info "  - Python version management"

    log_info ""
    log_info "Quick usage examples:"
    log_info "  uv pip install <package>    # Install packages"
    log_info "  uv venv                      # Create virtual environment"
    log_info "  uv init                      # Initialize a new project"
    log_info "  uv run script.py             # Run a script in an isolated environment"
    log_info "  uv python install 3.12       # Install Python 3.12"

    log_info ""
    log_info "UV setup completed successfully"
    log_info "Note: UV is added to PATH via ~/.cargo/env"
else
    log_error "UV installation failed"
    exit 1
fi

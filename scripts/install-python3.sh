#!/bin/bash

# Python3 Installation Script

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[PYTHON]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[PYTHON]${NC} $1"
}

# Check if Python3 is already installed
if command -v python3 &> /dev/null; then
    CURRENT_VERSION=$(python3 --version)
    log_warn "Python3 is already installed (${CURRENT_VERSION})"
else
    log_info "Installing Python3..."
    sudo apt-get install -y python3
fi

# Install pip
if command -v pip3 &> /dev/null; then
    log_warn "pip3 is already installed"
else
    log_info "Installing pip3..."
    sudo apt-get install -y python3-pip
fi

# Install python3-venv for virtual environments
log_info "Installing python3-venv..."
sudo apt-get install -y python3-venv

# Install development headers (useful for compiling Python packages)
log_info "Installing Python development headers..."
sudo apt-get install -y python3-dev build-essential

# Verify installation
if command -v python3 &> /dev/null && command -v pip3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    PIP_VERSION=$(pip3 --version | awk '{print $2}')
    log_info "Python3 installed successfully: ${PYTHON_VERSION}"
    log_info "pip3 version: ${PIP_VERSION}"

    # Upgrade pip to latest version
    log_info "Upgrading pip to latest version..."
    python3 -m pip install --user --upgrade pip

    log_info "Python3 setup completed successfully"
else
    log_error "Python3 installation failed"
    exit 1
fi

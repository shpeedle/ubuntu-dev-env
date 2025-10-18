#!/bin/bash

# Git Installation Script

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[GIT]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[GIT]${NC} $1"
}

# Check if Git is already installed
if command -v git &> /dev/null; then
    CURRENT_VERSION=$(git --version | awk '{print $3}')
    log_warn "Git is already installed (version ${CURRENT_VERSION})"
    read -p "Do you want to reinstall/update Git? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping Git installation"
        exit 0
    fi
fi

log_info "Installing Git..."

# Install Git
sudo apt-get install -y git

# Verify installation
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version)
    log_info "Git installed successfully: ${GIT_VERSION}"

    # Check if Git is configured
    if ! git config --global user.name &> /dev/null; then
        log_info "Git is not configured. Please set up your identity:"
        read -p "Enter your name: " git_name
        read -p "Enter your email: " git_email

        git config --global user.name "$git_name"
        git config --global user.email "$git_email"

        log_info "Git configuration completed"
    else
        log_info "Git is already configured:"
        echo "  Name: $(git config --global user.name)"
        echo "  Email: $(git config --global user.email)"
    fi
else
    log_error "Git installation failed"
    exit 1
fi

#!/bin/bash

# Rust Installation Script
# Installs Rust using rustup

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[RUST]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[RUST]${NC} $1"
}

# Check if Rust is already installed
if command -v rustc &> /dev/null; then
    CURRENT_VERSION=$(rustc --version)
    log_warn "Rust is already installed (${CURRENT_VERSION})"
    read -p "Do you want to update Rust? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Updating Rust..."
        rustup update
        log_info "Rust updated successfully"
    else
        log_info "Skipping Rust installation"
    fi
    exit 0
fi

log_info "Installing Rust..."

# Install dependencies for Rust
log_info "Installing build dependencies..."
sudo apt-get install -y build-essential curl

# Download and run rustup installer
log_info "Running rustup installer..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Source cargo environment
source "$HOME/.cargo/env"

# Verify installation
if command -v rustc &> /dev/null && command -v cargo &> /dev/null; then
    RUSTC_VERSION=$(rustc --version)
    CARGO_VERSION=$(cargo --version)
    log_info "Rust installed successfully: ${RUSTC_VERSION}"
    log_info "Cargo version: ${CARGO_VERSION}"

    # Add common components
    log_info "Installing common Rust components..."
    rustup component add rustfmt clippy

    log_info "Rust setup completed successfully"
    log_info "Note: Cargo environment is added to ~/.bashrc automatically"
else
    log_error "Rust installation failed"
    exit 1
fi

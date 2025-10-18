#!/bin/bash

# Build Tools Installation Script
# Installs build-essential and cmake

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[BUILD]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[BUILD]${NC} $1"
}

log_info "Installing build tools..."

# Check if build-essential is already installed
if dpkg -l | grep -q build-essential; then
    log_warn "build-essential is already installed"
else
    log_info "Installing build-essential (gcc, g++, make, etc.)..."
    sudo apt-get install -y build-essential
fi

# Check if cmake is already installed
if command -v cmake &> /dev/null; then
    CMAKE_VERSION=$(cmake --version 2>/dev/null | head -n 1 || true)
    log_warn "cmake is already installed (${CMAKE_VERSION})"
else
    log_info "Installing cmake..."
    sudo apt-get install -y cmake
fi

# Verify installations
log_info "Verifying installations..."

if command -v gcc &> /dev/null; then
    GCC_VERSION=$(gcc --version 2>/dev/null | head -n 1 || true)
    log_info "GCC: ${GCC_VERSION}"
fi

if command -v g++ &> /dev/null; then
    GPP_VERSION=$(g++ --version 2>/dev/null | head -n 1 || true)
    log_info "G++: ${GPP_VERSION}"
fi

if command -v make &> /dev/null; then
    MAKE_VERSION=$(make --version 2>/dev/null | head -n 1 || true)
    log_info "Make: ${MAKE_VERSION}"
fi

if command -v cmake &> /dev/null; then
    CMAKE_VERSION=$(cmake --version 2>/dev/null | head -n 1 || true)
    log_info "CMake: ${CMAKE_VERSION}"
fi

log_info "Build tools installation completed successfully"
log_info "You can now compile C/C++ programs and use cmake"

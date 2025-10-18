#!/bin/bash

# Golang Installation Script
# Downloads and installs the latest stable version of Go

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[GOLANG]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[GOLANG]${NC} $1"
}

# Go version to install (update this to install a different version)
GO_VERSION="1.23.2"

# Check if Go is already installed
if command -v go &> /dev/null; then
    CURRENT_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
    log_warn "Go is already installed (version ${CURRENT_VERSION})"
    read -p "Do you want to reinstall Go? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping Go installation"
        exit 0
    fi

    # Remove old installation
    log_info "Removing old Go installation..."
    sudo rm -rf /usr/local/go
fi

log_info "Installing Go ${GO_VERSION}..."

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    armv6l)
        ARCH="armv6l"
        ;;
    *)
        log_error "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Download Go
log_info "Downloading Go for linux-${ARCH}..."
cd /tmp
wget -q --show-progress "https://go.dev/dl/go${GO_VERSION}.linux-${ARCH}.tar.gz"

# Extract to /usr/local
log_info "Extracting Go to /usr/local..."
sudo tar -C /usr/local -xzf "go${GO_VERSION}.linux-${ARCH}.tar.gz"

# Clean up
rm "go${GO_VERSION}.linux-${ARCH}.tar.gz"

# Add Go to PATH in .bashrc if not already present
if ! grep -q "/usr/local/go/bin" ~/.bashrc; then
    echo '' >> ~/.bashrc
    echo '# Go' >> ~/.bashrc
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
    log_info "Added Go to PATH in ~/.bashrc"
fi

# Set up for current session
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Create GOPATH directories
mkdir -p $GOPATH/{bin,src,pkg}

# Verify installation
if command -v go &> /dev/null; then
    GO_VERSION_INSTALLED=$(go version)
    log_info "Go installed successfully: ${GO_VERSION_INSTALLED}"
    log_info "GOPATH: $GOPATH"
else
    log_error "Go installation failed"
    exit 1
fi

#!/bin/bash

# Infrastructure as Code Tools Installation Script
# Installs OpenTofu and Terrascan

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[IAC]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[IAC]${NC} $1"
}

log_error() {
    echo -e "${RED}[IAC]${NC} $1"
}

log_info "Installing Infrastructure as Code tools..."

# Install OpenTofu
log_info "Installing OpenTofu..."
if command -v tofu &> /dev/null; then
    TOFU_VERSION=$(tofu version | head -n1)
    log_warn "OpenTofu is already installed (${TOFU_VERSION})"
else
    # Download the installer script
    curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o /tmp/install-opentofu.sh
    chmod +x /tmp/install-opentofu.sh

    # Install OpenTofu
    sudo /tmp/install-opentofu.sh --install-method deb

    # Clean up
    rm /tmp/install-opentofu.sh

    if command -v tofu &> /dev/null; then
        TOFU_VERSION=$(tofu version | head -n1)
        log_info "OpenTofu installed: ${TOFU_VERSION}"
    fi
fi

# Install Terrascan
log_info "Installing Terrascan..."
if command -v terrascan &> /dev/null; then
    TERRASCAN_VERSION=$(terrascan version)
    log_warn "Terrascan is already installed (${TERRASCAN_VERSION})"
else
    # Determine architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            TERRASCAN_ARCH="x86_64"
            ;;
        aarch64)
            TERRASCAN_ARCH="arm64"
            ;;
        *)
            log_error "Unsupported architecture for Terrascan: $ARCH"
            TERRASCAN_ARCH=""
            ;;
    esac

    if [ -n "$TERRASCAN_ARCH" ]; then
        # Get latest version
        TERRASCAN_VERSION=$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

        if [ -z "$TERRASCAN_VERSION" ]; then
            log_warn "Could not determine latest Terrascan version, using v1.19.1"
            TERRASCAN_VERSION="1.19.1"
        fi

        log_info "Downloading Terrascan v${TERRASCAN_VERSION}..."
        curl -L "https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_${TERRASCAN_ARCH}.tar.gz" -o /tmp/terrascan.tar.gz

        # Extract and install
        tar -xzf /tmp/terrascan.tar.gz -C /tmp
        sudo install /tmp/terrascan /usr/local/bin/terrascan
        rm -f /tmp/terrascan.tar.gz /tmp/terrascan /tmp/CHANGELOG.md /tmp/LICENSE /tmp/README.md

        if command -v terrascan &> /dev/null; then
            TERRASCAN_VERSION=$(terrascan version)
            log_info "Terrascan installed: ${TERRASCAN_VERSION}"
        fi
    fi
fi

# Verify installations
log_info ""
log_info "Verifying installations..."

if command -v tofu &> /dev/null; then
    log_info "✓ OpenTofu: $(tofu version | head -n1)"
else
    log_warn "✗ OpenTofu not installed"
fi

if command -v terrascan &> /dev/null; then
    log_info "✓ Terrascan: $(terrascan version)"
else
    log_warn "✗ Terrascan not installed"
fi

log_info ""
log_info "Infrastructure as Code tools installation completed!"
log_info ""
log_info "OpenTofu commands:"
log_info "  tofu init                      # Initialize a working directory"
log_info "  tofu plan                      # Generate execution plan"
log_info "  tofu apply                     # Apply changes"
log_info "  tofu destroy                   # Destroy managed infrastructure"
log_info "  tofu validate                  # Validate configuration"
log_info "  tofu fmt                       # Format configuration files"
log_info "  tofu state list                # List resources in state"
log_info ""
log_info "Terrascan commands:"
log_info "  terrascan scan                 # Scan current directory"
log_info "  terrascan scan -t aws          # Scan for AWS"
log_info "  terrascan scan -t k8s          # Scan Kubernetes files"
log_info "  terrascan scan -d <dir>        # Scan specific directory"
log_info "  terrascan scan -i terraform    # Scan Terraform files"
log_info "  terrascan init                 # Initialize Terrascan"
log_info ""
log_info "OpenTofu is a Terraform-compatible open-source IaC tool"
log_info "Terrascan detects security vulnerabilities in IaC"

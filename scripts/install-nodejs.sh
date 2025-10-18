#!/bin/bash

# Node.js Installation Script
# Installs Node.js using nvm (Node Version Manager)

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[NODE]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[NODE]${NC} $1"
}

log_error() {
    echo -e "${RED}[NODE]${NC} $1"
}

# NVM version to install
NVM_VERSION="v0.40.1"

# Check if nvm is already installed
if [ -d "$HOME/.nvm" ] || command -v nvm &> /dev/null; then
    log_warn "nvm appears to be already installed"

    # Try to load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if command -v nvm &> /dev/null; then
        NVM_CURRENT=$(nvm --version)
        log_warn "nvm version: ${NVM_CURRENT}"

        read -p "Do you want to reinstall nvm? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            # Check if Node.js is installed via nvm
            if command -v node &> /dev/null; then
                NODE_VERSION=$(node --version)
                log_info "Node.js is already installed: ${NODE_VERSION}"
                log_info "Skipping installation"
            else
                log_info "Installing Node.js LTS via existing nvm..."
                nvm install --lts
                nvm use --lts
                nvm alias default 'lts/*'
            fi
            exit 0
        fi

        # Backup existing nvm directory
        log_info "Backing up existing nvm installation..."
        mv "$HOME/.nvm" "$HOME/.nvm.backup.$(date +%s)"
    fi
fi

log_info "Installing nvm ${NVM_VERSION}..."

# Install dependencies
log_info "Installing dependencies..."
sudo apt-get install -y curl

# Download and install nvm
log_info "Downloading and installing nvm..."
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash

# Load nvm for current session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Verify nvm installation
if ! command -v nvm &> /dev/null; then
    log_error "nvm installation failed"
    exit 1
fi

NVM_INSTALLED_VERSION=$(nvm --version)
log_info "nvm installed successfully: ${NVM_INSTALLED_VERSION}"

# Install Node.js LTS version
log_info "Installing Node.js LTS version..."
nvm install --lts

# Set LTS as default
log_info "Setting LTS as default Node.js version..."
nvm use --lts
nvm alias default 'lts/*'

# Verify Node.js installation
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    NODE_VERSION=$(node --version)
    NPM_VERSION=$(npm --version)
    log_info "Node.js installed successfully: ${NODE_VERSION}"
    log_info "npm version: ${NPM_VERSION}"

    log_info ""
    log_info "nvm commands:"
    log_info "  nvm install <version>     # Install a specific Node.js version"
    log_info "  nvm install --lts         # Install latest LTS version"
    log_info "  nvm use <version>         # Use a specific version"
    log_info "  nvm ls                    # List installed versions"
    log_info "  nvm ls-remote             # List available versions"
    log_info "  nvm alias default <ver>   # Set default version"

    log_info ""
    log_info "Node.js setup completed successfully"
    log_info "Note: nvm configuration has been added to ~/.bashrc"
else
    log_error "Node.js installation failed"
    exit 1
fi

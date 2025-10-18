#!/bin/bash

# Google Chrome Installation Script
# Installs Google Chrome from official Google repository

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[CHROME]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[CHROME]${NC} $1"
}

log_error() {
    echo -e "${RED}[CHROME]${NC} $1"
}

log_info "Installing Google Chrome..."

# Check if Chrome is already installed
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    log_warn "Google Chrome is already installed (${CHROME_VERSION})"
    read -p "Do you want to reinstall/update Google Chrome? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping Google Chrome installation"
        exit 0
    fi
fi

log_info "Installing Google Chrome from official repository..."

# Install prerequisites
sudo apt-get update
sudo apt-get install -y wget apt-transport-https

# Download Google's signing key
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg

# Add Google Chrome repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list

# Update package list
sudo apt-get update

# Install Google Chrome Stable
sudo apt-get install -y google-chrome-stable

# Verify installation
if command -v google-chrome &> /dev/null; then
    CHROME_VERSION=$(google-chrome --version)
    log_info "Google Chrome installed successfully: ${CHROME_VERSION}"

    log_info ""
    log_info "Google Chrome installation completed!"
    log_info ""
    log_info "Launch Chrome:"
    log_info "  google-chrome                    # Launch from command line"
    log_info "  google-chrome --incognito        # Open in incognito mode"
    log_info "  google-chrome <url>              # Open specific URL"
    log_info ""
    log_info "Or search for 'Google Chrome' in your application menu"
    log_info ""
    log_info "Useful command-line flags:"
    log_info "  --new-window                     # Open in new window"
    log_info "  --new-tab                        # Open in new tab"
    log_info "  --disable-gpu                    # Disable GPU acceleration"
    log_info "  --headless                       # Run in headless mode (no UI)"
    log_info "  --user-data-dir=/path            # Use custom profile directory"
    log_info ""
    log_info "Chrome will auto-update through the system package manager"
else
    log_error "Google Chrome installation failed"
    exit 1
fi

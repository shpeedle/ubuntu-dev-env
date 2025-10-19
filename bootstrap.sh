#!/bin/bash

# Bootstrap script to install Ansible and run the setup playbook
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[BOOTSTRAP]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[BOOTSTRAP]${NC} $1"
}

log_info "Ubuntu Development Environment Bootstrap"
log_info "========================================"

# Check if running on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    log_warn "This script is designed for Ubuntu."
    exit 1
fi

# Check if Ansible is already installed
if command -v ansible-playbook &> /dev/null; then
    log_info "Ansible is already installed"
else
    log_info "Installing Ansible..."
    sudo apt-get update
    sudo apt-get install -y software-properties-common
    sudo add-apt-repository --yes ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install -y ansible
    log_info "Ansible installed successfully"
fi

# Run the playbook
log_info "Running setup playbook..."
ansible-playbook setup.yml --ask-become-pass

log_info ""
log_info "========================================"
log_info "Setup completed successfully!"
log_info ""
log_info "IMPORTANT:"
log_info "  - Log out and log back in to:"
log_info "    * Use zsh as your default shell"
log_info "    * Run Docker without sudo"
log_info "  - After logging back in, run 'source ~/.zshrc'"

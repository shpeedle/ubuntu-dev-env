#!/bin/bash

# Ansible Installation Script
# Installs Ansible automation platform

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[ANSIBLE]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[ANSIBLE]${NC} $1"
}

log_error() {
    echo -e "${RED}[ANSIBLE]${NC} $1"
}

log_info "Installing Ansible..."

# Check if Ansible is already installed
if command -v ansible &> /dev/null; then
    ANSIBLE_VERSION=$(ansible --version | head -n1)
    log_warn "Ansible is already installed (${ANSIBLE_VERSION})"
    read -p "Do you want to reinstall/update Ansible? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping Ansible installation"
        exit 0
    fi
fi

log_info "Installing Ansible from official PPA..."

# Add Ansible PPA
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Ansible
sudo apt-get install -y ansible

# Verify installation
if command -v ansible &> /dev/null; then
    ANSIBLE_VERSION=$(ansible --version | head -n1)
    log_info "Ansible installed: ${ANSIBLE_VERSION}"

    # Also check for ansible-playbook
    if command -v ansible-playbook &> /dev/null; then
        log_info "ansible-playbook is available"
    fi

    # Check for ansible-galaxy
    if command -v ansible-galaxy &> /dev/null; then
        log_info "ansible-galaxy is available"
    fi

    # Create ansible config directory
    if [ ! -d "$HOME/.ansible" ]; then
        mkdir -p "$HOME/.ansible"
        log_info "Created ~/.ansible directory"
    fi

    # Create a basic ansible.cfg if it doesn't exist
    if [ ! -f "$HOME/.ansible.cfg" ]; then
        log_info "Creating basic ansible.cfg..."
        cat > "$HOME/.ansible.cfg" << 'EOF'
[defaults]
inventory = ~/.ansible/inventory
host_key_checking = False
retry_files_enabled = False
gathering = smart
fact_caching = jsonfile
fact_caching_connection = ~/.ansible/facts
fact_caching_timeout = 3600

[privilege_escalation]
become = True
become_method = sudo
become_user = root
become_ask_pass = False
EOF
        log_info "Created ~/.ansible.cfg with sensible defaults"
    fi

    # Create inventory directory
    if [ ! -d "$HOME/.ansible/inventory" ]; then
        mkdir -p "$HOME/.ansible/inventory"
        log_info "Created ~/.ansible/inventory directory"
    fi

    log_info ""
    log_info "Ansible installation completed!"
    log_info ""
    log_info "Ansible commands:"
    log_info ""
    log_info "Ad-hoc commands:"
    log_info "  ansible all -m ping            # Test connection to all hosts"
    log_info "  ansible all -m setup            # Gather facts from all hosts"
    log_info "  ansible webservers -a 'uptime' # Run command on webservers group"
    log_info "  ansible all -m apt -a 'name=vim state=present' --become"
    log_info ""
    log_info "Playbooks:"
    log_info "  ansible-playbook site.yml      # Run playbook"
    log_info "  ansible-playbook site.yml --check  # Dry run"
    log_info "  ansible-playbook site.yml --limit webservers  # Run on specific hosts"
    log_info "  ansible-playbook site.yml --tags config       # Run specific tags"
    log_info "  ansible-playbook site.yml -v   # Verbose output"
    log_info ""
    log_info "Ansible Galaxy (community roles and collections):"
    log_info "  ansible-galaxy install geerlingguy.docker      # Install role"
    log_info "  ansible-galaxy collection install community.general  # Install collection"
    log_info "  ansible-galaxy list            # List installed roles/collections"
    log_info ""
    log_info "Inventory management:"
    log_info "  ansible-inventory --list       # View inventory"
    log_info "  ansible-inventory --graph      # View inventory as graph"
    log_info ""
    log_info "Configuration file: ~/.ansible.cfg"
    log_info "Add your hosts to: ~/.ansible/inventory/"
else
    log_error "Ansible installation failed"
    exit 1
fi

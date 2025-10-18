#!/bin/bash

# Ubuntu Development Environment Setup Script
# This script installs essential development tools on a fresh Ubuntu installation

set -e  # Exit on error
set -o pipefail  # Exit on pipe failures

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    log_error "This script is designed for Ubuntu. Detected OS: $(cat /etc/os-release | grep PRETTY_NAME)"
    exit 1
fi

log_info "Starting Ubuntu Development Environment Setup"
log_info "========================================"

# Update package lists
log_info "Updating package lists..."
sudo apt-get update

# Create scripts directory if it doesn't exist
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_PATH="${SCRIPT_DIR}/scripts"

# Array of installation scripts
# Order matters! Dependencies must be installed first.
declare -a INSTALL_SCRIPTS=(
    "install-build-tools.sh"      # First: provides gcc, make, cmake
    "install-git.sh"               # Early: needed by cli-tools (fzf), git-tools
    "install-cli-tools.sh"         # After git: fzf uses git clone
    "install-git-tools.sh"         # After git: gh, glab, lazygit
    "install-python3.sh"           # Before ansible, uv
    "install-uv.sh"                # After python3 (optional dependency)
    "install-nodejs.sh"            # Independent
    "install-golang.sh"            # Independent
    "install-rust.sh"              # Independent
    "install-docker.sh"            # Before kubernetes/security tools (optional)
    "install-kubernetes-tools.sh"  # Independent
    "install-iac-tools.sh"         # Independent (OpenTofu, Terrascan)
    "install-security-tools.sh"    # Independent (Trivy)
    "install-ansible.sh"           # After python3: requires Python
    "install-aws-cli.sh"           # Independent
    "install-tmux.sh"              # Independent
    "install-neovim.sh"            # After python3/nodejs (optional providers)
    "install-vscode.sh"            # Near end: large installation
    "install-chrome.sh"            # GUI application
    "install-zsh.sh"               # Last: changes default shell
)

# Execute each installation script
for script in "${INSTALL_SCRIPTS[@]}"; do
    script_path="${SCRIPTS_PATH}/${script}"
    if [ -f "$script_path" ]; then
        log_info "Running ${script}..."
        bash "$script_path"
        if [ $? -eq 0 ]; then
            log_info "${script} completed successfully"
        else
            log_error "${script} failed"
            exit 1
        fi
    else
        log_error "Script not found: ${script_path}"
        exit 1
    fi
done

log_info "========================================"
log_info "Setup completed successfully!"
log_info ""
log_info "Installed tools:"
log_info "  - Build Tools (gcc, g++, make, cmake)"
log_info "  - Essential CLI Tools (fzf, ripgrep, bat, fd, eza, jq, yq, htop, tldr, ncdu)"
log_info "  - Git"
log_info "  - Git Tools (GitHub CLI, GitLab CLI, lazygit)"
log_info "  - Python3"
log_info "  - UV (Astral)"
log_info "  - Node.js & npm (via nvm)"
log_info "  - Golang"
log_info "  - Rust & Cargo"
log_info "  - Docker & Docker Compose"
log_info "  - Kubernetes Tools (kubectl)"
log_info "  - IaC Tools (OpenTofu, Terrascan)"
log_info "  - Security Tools (Trivy)"
log_info "  - Ansible"
log_info "  - AWS CLI"
log_info "  - Tmux (terminal multiplexer)"
log_info "  - Neovim"
log_info "  - Visual Studio Code"
log_info "  - Google Chrome"
log_info "  - Zsh with Oh-My-Zsh"
log_info ""
log_info "IMPORTANT:"
log_info "  - Log out and log back in to use zsh as your default shell"
log_info "  - For Docker without sudo, log out and log back in"
log_info "  - After logging back in, run 'source ~/.zshrc' or restart terminal"

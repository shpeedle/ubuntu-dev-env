#!/bin/bash

# Essential CLI Tools Installation Script
# Installs modern replacements and enhancements for common CLI tools

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[CLI-TOOLS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[CLI-TOOLS]${NC} $1"
}

log_error() {
    echo -e "${RED}[CLI-TOOLS]${NC} $1"
}

log_info "Installing essential CLI tools..."

# Install tools available in Ubuntu repositories
log_info "Installing tools from Ubuntu repositories..."
sudo apt-get install -y \
    jq \
    htop \
    silversearcher-ag \
    tree \
    ncdu

# Install ripgrep
log_info "Installing ripgrep..."
if command -v rg &> /dev/null; then
    log_warn "ripgrep is already installed"
else
    sudo apt-get install -y ripgrep
fi

# Install fd-find (installed as fdfind in Ubuntu)
log_info "Installing fd..."
if command -v fd &> /dev/null || command -v fdfind &> /dev/null; then
    log_warn "fd is already installed"
else
    sudo apt-get install -y fd-find
    # Create fd symlink if it doesn't exist
    if [ ! -f "$HOME/.local/bin/fd" ]; then
        mkdir -p ~/.local/bin
        ln -s $(which fdfind) ~/.local/bin/fd
        log_info "Created fd symlink at ~/.local/bin/fd"
    fi
fi

# Install bat
log_info "Installing bat..."
if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
    log_warn "bat is already installed"
else
    sudo apt-get install -y bat
    # Create bat symlink if it doesn't exist (Ubuntu installs it as batcat)
    if [ ! -f "$HOME/.local/bin/bat" ]; then
        mkdir -p ~/.local/bin
        ln -s $(which batcat) ~/.local/bin/bat
        log_info "Created bat symlink at ~/.local/bin/bat"
    fi
fi

# Install fzf
log_info "Installing fzf..."
if command -v fzf &> /dev/null; then
    log_warn "fzf is already installed"
else
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all --no-bash --no-fish
    log_info "fzf installed and configured for zsh"
fi

# Install eza (modern ls replacement)
log_info "Installing eza..."
if command -v eza &> /dev/null; then
    log_warn "eza is already installed"
else
    # Install eza from their repository
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt-get update
    sudo apt-get install -y eza
fi

# Install tldr
log_info "Installing tldr..."
if command -v tldr &> /dev/null; then
    log_warn "tldr is already installed"
else
    sudo apt-get install -y tldr
    # Update tldr cache
    tldr --update &> /dev/null || true
fi

# Install yq (YAML processor)
log_info "Installing yq..."
if command -v yq &> /dev/null; then
    YQ_VERSION=$(yq --version 2>&1 || true)
    log_warn "yq is already installed (${YQ_VERSION})"
else
    # Install latest yq binary
    YQ_VERSION="v4.44.3"
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            YQ_BINARY="yq_linux_amd64"
            ;;
        aarch64)
            YQ_BINARY="yq_linux_arm64"
            ;;
        *)
            log_warn "Unsupported architecture for yq: $ARCH, skipping..."
            YQ_BINARY=""
            ;;
    esac

    if [ -n "$YQ_BINARY" ]; then
        wget -q "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY}" -O /tmp/yq
        sudo install /tmp/yq /usr/local/bin/yq
        rm /tmp/yq
        log_info "yq installed successfully"
    fi
fi

# Add useful aliases to .zshrc if zsh is installed
if [ -f "$HOME/.zshrc" ]; then
    log_info "Adding CLI tool aliases to ~/.zshrc..."

    # Check if our aliases section already exists
    if ! grep -q "# Enhanced CLI tools aliases" "$HOME/.zshrc"; then
        cat >> "$HOME/.zshrc" << 'EOF'

# Enhanced CLI tools aliases
alias cat='bat --paging=never'
alias catp='bat'  # cat with paging
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias lt='eza -T --icons'  # tree view
alias l='eza -l --icons'
alias find='fd'
alias grep='rg'
alias top='htop'
alias du='ncdu'

# fzf helpers
alias fzfp='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# Quick edits
alias zshconfig='${EDITOR:-vim} ~/.zshrc'
alias tmuxconfig='${EDITOR:-vim} ~/.tmux.conf'
EOF
        log_info "Added CLI tool aliases to ~/.zshrc"
    else
        log_warn "CLI tool aliases already exist in ~/.zshrc"
    fi
fi

# Add useful aliases to .bashrc if bash is the shell
if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
    log_info "Adding CLI tool aliases to ~/.bashrc..."

    if ! grep -q "# Enhanced CLI tools aliases" "$HOME/.bashrc"; then
        cat >> "$HOME/.bashrc" << 'EOF'

# Enhanced CLI tools aliases
alias cat='bat --paging=never'
alias catp='bat'  # cat with paging
alias ls='eza --icons'
alias ll='eza -la --icons --git'
alias lt='eza -T --icons'  # tree view
alias l='eza -l --icons'
alias find='fd'
alias grep='rg'
alias top='htop'
alias du='ncdu'

# fzf helpers
alias fzfp='fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
EOF
        log_info "Added CLI tool aliases to ~/.bashrc"
    else
        log_warn "CLI tool aliases already exist in ~/.bashrc"
    fi
fi

# Verify installations
log_info ""
log_info "Verifying installations..."

command -v rg &> /dev/null && log_info "ripgrep: $(rg --version 2>/dev/null | head -n1 || true)"
command -v fd &> /dev/null && log_info "fd: $(fd --version)"
command -v fdfind &> /dev/null && [ ! -f "$HOME/.local/bin/fd" ] && log_info "fd: installed as fdfind"
command -v bat &> /dev/null && log_info "bat: $(bat --version)"
command -v batcat &> /dev/null && [ ! -f "$HOME/.local/bin/bat" ] && log_info "bat: installed as batcat"
command -v fzf &> /dev/null && log_info "fzf: $(fzf --version)"
command -v eza &> /dev/null && log_info "eza: $(eza --version 2>/dev/null | head -n1 || true)"
command -v jq &> /dev/null && log_info "jq: $(jq --version)"
command -v yq &> /dev/null && log_info "yq: $(yq --version)"
command -v htop &> /dev/null && log_info "htop: $(htop --version 2>/dev/null | head -n1 || true)"
command -v tldr &> /dev/null && log_info "tldr: installed"
command -v ncdu &> /dev/null && log_info "ncdu: $(ncdu --version 2>/dev/null | head -n1 || true)"

log_info ""
log_info "Essential CLI tools installed successfully!"
log_info ""
log_info "Quick reference:"
log_info "  rg <pattern>              - Search for text in files (faster grep)"
log_info "  fd <pattern>              - Find files by name (faster find)"
log_info "  bat <file>                - View file with syntax highlighting"
log_info "  fzf                       - Fuzzy finder (try: Ctrl+R for history)"
log_info "  eza -la                   - Better ls with icons and git status"
log_info "  jq '.' file.json          - Format and query JSON"
log_info "  yq '.' file.yaml          - Format and query YAML"
log_info "  htop                      - Interactive process viewer"
log_info "  tldr <command>            - Quick command examples"
log_info "  ncdu                      - Disk usage analyzer"
log_info ""
log_info "Note: Restart your terminal or run 'source ~/.zshrc' to use aliases"

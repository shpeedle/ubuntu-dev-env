#!/bin/bash

# Git Tools Installation Script
# Installs GitHub CLI (gh), GitLab CLI (glab), and lazygit

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[GIT-TOOLS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[GIT-TOOLS]${NC} $1"
}

log_error() {
    echo -e "${RED}[GIT-TOOLS]${NC} $1"
}

log_info "Installing Git enhancement tools..."

# Install GitHub CLI (gh)
log_info "Installing GitHub CLI (gh)..."
if command -v gh &> /dev/null; then
    GH_VERSION=$(gh --version | head -n1)
    log_warn "GitHub CLI is already installed (${GH_VERSION})"
else
    # Add GitHub CLI repository
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    sudo apt-get update
    sudo apt-get install -y gh

    if command -v gh &> /dev/null; then
        GH_VERSION=$(gh --version | head -n1)
        log_info "GitHub CLI installed: ${GH_VERSION}"
    fi
fi

# Install GitLab CLI (glab)
log_info "Installing GitLab CLI (glab)..."
if command -v glab &> /dev/null; then
    GLAB_VERSION=$(glab --version)
    log_warn "GitLab CLI is already installed (${GLAB_VERSION})"
else
    # Determine architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            GLAB_ARCH="amd64"
            ;;
        aarch64)
            GLAB_ARCH="arm64"
            ;;
        *)
            log_error "Unsupported architecture for glab: $ARCH"
            GLAB_ARCH=""
            ;;
    esac

    if [ -n "$GLAB_ARCH" ]; then
        # Get latest version from GitHub API
        GLAB_VERSION=$(curl -s https://api.github.com/repos/profclems/glab/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

        if [ -z "$GLAB_VERSION" ]; then
            log_warn "Could not determine latest glab version, using v1.42.0"
            GLAB_VERSION="1.42.0"
        fi

        log_info "Downloading glab v${GLAB_VERSION}..."
        wget -q "https://github.com/profclems/glab/releases/download/v${GLAB_VERSION}/glab_${GLAB_VERSION}_Linux_${GLAB_ARCH}.tar.gz" -O /tmp/glab.tar.gz

        # Extract and install
        tar -xzf /tmp/glab.tar.gz -C /tmp
        sudo install /tmp/bin/glab /usr/local/bin/glab
        rm -rf /tmp/glab.tar.gz /tmp/bin

        if command -v glab &> /dev/null; then
            GLAB_VERSION=$(glab --version)
            log_info "GitLab CLI installed: ${GLAB_VERSION}"
        fi
    fi
fi

# Install lazygit
log_info "Installing lazygit..."
if command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(lazygit --version | head -n1)
    log_warn "lazygit is already installed (${LAZYGIT_VERSION})"
else
    # Determine architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            LAZYGIT_ARCH="x86_64"
            ;;
        aarch64)
            LAZYGIT_ARCH="arm64"
            ;;
        armv6l)
            LAZYGIT_ARCH="armv6"
            ;;
        *)
            log_error "Unsupported architecture for lazygit: $ARCH"
            LAZYGIT_ARCH=""
            ;;
    esac

    if [ -n "$LAZYGIT_ARCH" ]; then
        # Get latest version from GitHub API
        LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | sed -E 's/.*"v([^"]+)".*/\1/')

        if [ -z "$LAZYGIT_VERSION" ]; then
            log_warn "Could not determine latest lazygit version, using v0.43.1"
            LAZYGIT_VERSION="0.43.1"
        fi

        log_info "Downloading lazygit v${LAZYGIT_VERSION}..."
        wget -q "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz" -O /tmp/lazygit.tar.gz

        # Extract and install
        tar -xzf /tmp/lazygit.tar.gz -C /tmp
        sudo install /tmp/lazygit /usr/local/bin/lazygit
        rm -f /tmp/lazygit.tar.gz /tmp/lazygit

        if command -v lazygit &> /dev/null; then
            LAZYGIT_VERSION=$(lazygit --version | head -n1)
            log_info "lazygit installed: ${LAZYGIT_VERSION}"
        fi
    fi
fi

# Verify installations
log_info ""
log_info "Verifying installations..."

if command -v gh &> /dev/null; then
    log_info "✓ GitHub CLI: $(gh --version | head -n1)"
else
    log_warn "✗ GitHub CLI not installed"
fi

if command -v glab &> /dev/null; then
    log_info "✓ GitLab CLI: $(glab --version)"
else
    log_warn "✗ GitLab CLI not installed"
fi

if command -v lazygit &> /dev/null; then
    log_info "✓ lazygit: $(lazygit --version | head -n1)"
else
    log_warn "✗ lazygit not installed"
fi

log_info ""
log_info "Git tools installation completed!"
log_info ""
log_info "Quick start guide:"
log_info ""
log_info "GitHub CLI (gh):"
log_info "  gh auth login              # Authenticate with GitHub"
log_info "  gh repo list               # List your repositories"
log_info "  gh pr create               # Create a pull request"
log_info "  gh pr list                 # List pull requests"
log_info "  gh pr view                 # View pull request details"
log_info "  gh issue create            # Create an issue"
log_info "  gh issue list              # List issues"
log_info "  gh repo clone <repo>       # Clone a repository"
log_info ""
log_info "GitLab CLI (glab):"
log_info "  glab auth login            # Authenticate with GitLab"
log_info "  glab repo list             # List your repositories"
log_info "  glab mr create             # Create a merge request"
log_info "  glab mr list               # List merge requests"
log_info "  glab mr view               # View merge request details"
log_info "  glab issue create          # Create an issue"
log_info "  glab issue list            # List issues"
log_info "  glab repo clone <repo>     # Clone a repository"
log_info ""
log_info "lazygit:"
log_info "  lazygit                    # Launch lazygit TUI"
log_info "  (Navigate with arrows, ? for help)"
log_info ""
log_info "Run 'gh auth login' to authenticate with GitHub"
log_info "Run 'glab auth login' to authenticate with GitLab"

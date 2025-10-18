#!/bin/bash

# Zsh Installation Script
# Installs zsh with oh-my-zsh and configures it out of the box

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[ZSH]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[ZSH]${NC} $1"
}

log_error() {
    echo -e "${RED}[ZSH]${NC} $1"
}

# Check if zsh is already installed
if command -v zsh &> /dev/null; then
    ZSH_VERSION=$(zsh --version)
    log_warn "zsh is already installed (${ZSH_VERSION})"
else
    log_info "Installing zsh..."
    sudo apt-get install -y zsh
fi

# Verify zsh installation
if ! command -v zsh &> /dev/null; then
    log_error "zsh installation failed"
    exit 1
fi

ZSH_VERSION=$(zsh --version)
log_info "zsh installed: ${ZSH_VERSION}"

# Check if oh-my-zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    log_warn "oh-my-zsh is already installed"
    read -p "Do you want to reinstall oh-my-zsh? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Backing up existing oh-my-zsh..."
        mv "$HOME/.oh-my-zsh" "$HOME/.oh-my-zsh.backup.$(date +%s)"
        if [ -f "$HOME/.zshrc" ]; then
            mv "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
        fi
    else
        log_info "Keeping existing oh-my-zsh installation"

        # Still offer to change default shell
        CURRENT_SHELL=$(basename "$SHELL")
        if [ "$CURRENT_SHELL" != "zsh" ]; then
            read -p "Do you want to set zsh as your default shell? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                log_info "Setting zsh as default shell..."
                sudo chsh -s $(which zsh) $USER
                log_info "Default shell changed to zsh. Please log out and log back in for changes to take effect."
            fi
        fi
        exit 0
    fi
fi

# Install oh-my-zsh
log_info "Installing oh-my-zsh..."
export RUNZSH=no  # Don't run zsh immediately after installation
export CHSH=no    # Don't change shell yet (we'll do it manually)

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install popular oh-my-zsh plugins
log_info "Installing zsh-autosuggestions plugin..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

log_info "Installing zsh-syntax-highlighting plugin..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Configure .zshrc with sensible defaults
log_info "Configuring .zshrc with enhanced settings..."

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
fi

cat > "$HOME/.zshrc" << 'EOF'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    docker
    docker-compose
    npm
    node
    python
    rust
    golang
    kubectl
    terraform
    ansible
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Preferred editor
export EDITOR='vim'

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias c='clear'

# Docker aliases
alias dps='docker ps'
alias dpa='docker ps -a'
alias dim='docker images'
alias dex='docker exec -it'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dclogs='docker-compose logs -f'

# Git aliases (in addition to oh-my-zsh git plugin)
alias gst='git status'
alias glog='git log --oneline --graph --decorate'
alias gcom='git commit -m'
alias gpush='git push'
alias gpull='git pull'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Cargo/Rust configuration
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# Go configuration
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# Add local bin to PATH
export PATH=$HOME/.local/bin:$PATH

# Enable autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

# Custom functions
mkcd() {
    mkdir -p "$1" && cd "$1"
}

extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
EOF

log_info "Created ~/.zshrc with enhanced configuration"

# Change default shell to zsh
CURRENT_SHELL=$(basename "$SHELL")
if [ "$CURRENT_SHELL" != "zsh" ]; then
    log_info "Setting zsh as default shell..."
    sudo chsh -s $(which zsh) $USER
    log_warn "Default shell changed to zsh"
    log_warn "You need to log out and log back in for the change to take effect"
else
    log_info "zsh is already the default shell"
fi

log_info ""
log_info "Zsh features installed:"
log_info "  - oh-my-zsh framework"
log_info "  - robbyrussell theme"
log_info "  - zsh-autosuggestions (suggests commands as you type)"
log_info "  - zsh-syntax-highlighting (highlights commands)"
log_info "  - Useful plugins: git, docker, python, node, rust, golang, kubectl, etc."
log_info "  - Helpful aliases and functions"
log_info ""
log_info "To customize further, edit ~/.zshrc"
log_info "To change theme, edit ZSH_THEME in ~/.zshrc"
log_info "Popular themes: agnoster, powerlevel10k, spaceship"
log_info ""
log_info "zsh setup completed successfully"

#!/bin/bash

# Tmux Installation Script
# Installs tmux with a sensible default configuration

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[TMUX]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[TMUX]${NC} $1"
}

# Check if tmux is already installed
if command -v tmux &> /dev/null; then
    TMUX_VERSION=$(tmux -V)
    log_warn "tmux is already installed (${TMUX_VERSION})"
    read -p "Do you want to reinstall tmux? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping tmux installation"
        exit 0
    fi
fi

log_info "Installing tmux..."

# Install tmux
sudo apt-get install -y tmux

# Verify installation
if command -v tmux &> /dev/null; then
    TMUX_VERSION=$(tmux -V)
    log_info "tmux installed successfully: ${TMUX_VERSION}"

    # Create a basic tmux configuration file if it doesn't exist
    if [ ! -f "$HOME/.tmux.conf" ]; then
        log_info "Creating default tmux configuration..."
        cat > "$HOME/.tmux.conf" << 'EOF'
# Tmux Configuration

# Set prefix to Ctrl-a (instead of Ctrl-b)
unbind C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# Enable mouse mode
set -g mouse on

# Split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config file with r
bind r source-file ~/.tmux.conf \; display "Config reloaded!"

# Switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Start window numbering at 1
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer size
set -g history-limit 10000

# Enable activity alerts
setw -g monitor-activity on
set -g visual-activity on

# Set 256 colors
set -g default-terminal "screen-256color"

# Status bar styling
set -g status-bg colour235
set -g status-fg colour248
set -g status-left '#[fg=colour45,bold] #S '
set -g status-right '#[fg=colour39]%H:%M #[fg=colour248]%d-%b-%y'

# Active pane border color
set -g pane-active-border-style fg=colour45

# Message styling
set -g message-style bg=colour235,fg=colour45,bold
EOF
        log_info "Created ~/.tmux.conf with sensible defaults"
    else
        log_warn "~/.tmux.conf already exists, skipping configuration"
    fi

    log_info ""
    log_info "Quick tmux guide:"
    log_info "  Ctrl+a is the prefix key"
    log_info "  Ctrl+a | - Split pane vertically"
    log_info "  Ctrl+a - - Split pane horizontally"
    log_info "  Alt+Arrow - Switch between panes"
    log_info "  Ctrl+a c - Create new window"
    log_info "  Ctrl+a n - Next window"
    log_info "  Ctrl+a p - Previous window"
    log_info "  Ctrl+a d - Detach from session"
    log_info "  tmux attach - Reattach to session"
    log_info "  Ctrl+a r - Reload configuration"
    log_info "  Mouse support is enabled"

    log_info ""
    log_info "tmux setup completed successfully"
else
    log_error "tmux installation failed"
    exit 1
fi

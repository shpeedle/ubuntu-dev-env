#!/bin/bash

# Neovim Installation Script
# Installs Neovim from official PPA or AppImage

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[NEOVIM]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[NEOVIM]${NC} $1"
}

log_error() {
    echo -e "${RED}[NEOVIM]${NC} $1"
}

log_info "Installing Neovim..."

# Check if Neovim is already installed
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version 2>/dev/null | head -n1 || true)
    log_warn "Neovim is already installed (${NVIM_VERSION})"
    read -p "Do you want to reinstall/update Neovim? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping Neovim installation"
        exit 0
    fi
fi

log_info "Installing Neovim from unstable PPA (latest stable version)..."

# Add Neovim PPA (unstable has the latest stable releases)
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes ppa:neovim-ppa/unstable

# Update and install
sudo apt-get update
sudo apt-get install -y neovim

# Install python3-neovim for plugin support
log_info "Installing Python provider for Neovim..."
sudo apt-get install -y python3-neovim

# Install node provider if node is available
if command -v npm &> /dev/null; then
    log_info "Installing Node.js provider for Neovim..."
    npm install -g neovim
fi

# Verify installation
if command -v nvim &> /dev/null; then
    NVIM_VERSION=$(nvim --version 2>/dev/null | head -n1 || true)
    log_info "Neovim installed successfully: ${NVIM_VERSION}"

    # Create config directory if it doesn't exist
    if [ ! -d "$HOME/.config/nvim" ]; then
        mkdir -p "$HOME/.config/nvim"
        log_info "Created ~/.config/nvim directory"
    fi

    # Create a basic init.vim if it doesn't exist
    if [ ! -f "$HOME/.config/nvim/init.vim" ]; then
        log_info "Creating basic init.vim configuration..."
        cat > "$HOME/.config/nvim/init.vim" << 'EOF'
" Basic Neovim Configuration

" Enable line numbers
set number
set relativenumber

" Enable syntax highlighting
syntax on

" Set tab width
set tabstop=4
set shiftwidth=4
set expandtab

" Enable mouse support
set mouse=a

" Enable clipboard support
set clipboard=unnamedplus

" Search settings
set ignorecase
set smartcase
set incsearch
set hlsearch

" Enable auto-indentation
set autoindent
set smartindent

" Show matching brackets
set showmatch

" Enable true color support
set termguicolors

" Disable swap files
set noswapfile
set nobackup

" Better command line completion
set wildmenu
set wildmode=list:longest,full

" Always show status line
set laststatus=2

" Show command in bottom bar
set showcmd

" Highlight current line
set cursorline

" File encoding
set encoding=utf-8

" Enable folding
set foldmethod=indent
set foldlevel=99

" Key mappings
let mapleader = " "

" Easy navigation between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlighting
nnoremap <leader><space> :nohlsearch<CR>

" Quick save
nnoremap <leader>w :w<CR>

" Quick quit
nnoremap <leader>q :q<CR>

" Toggle line numbers
nnoremap <leader>n :set number! relativenumber!<CR>
EOF
        log_info "Created ~/.config/nvim/init.vim with sensible defaults"
    else
        log_warn "~/.config/nvim/init.vim already exists, skipping configuration"
    fi

    # Add vim alias to use neovim
    if [ -f "$HOME/.zshrc" ]; then
        if ! grep -q "alias vim='nvim'" "$HOME/.zshrc"; then
            echo "" >> "$HOME/.zshrc"
            echo "# Use Neovim instead of Vim" >> "$HOME/.zshrc"
            echo "alias vim='nvim'" >> "$HOME/.zshrc"
            echo "alias vi='nvim'" >> "$HOME/.zshrc"
            log_info "Added vim/vi aliases to ~/.zshrc"
        fi
    fi

    if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
        if ! grep -q "alias vim='nvim'" "$HOME/.bashrc"; then
            echo "" >> "$HOME/.bashrc"
            echo "# Use Neovim instead of Vim" >> "$HOME/.bashrc"
            echo "alias vim='nvim'" >> "$HOME/.bashrc"
            echo "alias vi='nvim'" >> "$HOME/.bashrc"
            log_info "Added vim/vi aliases to ~/.bashrc"
        fi
    fi

    log_info ""
    log_info "Neovim installation completed!"
    log_info ""
    log_info "Quick start:"
    log_info "  nvim                   # Start Neovim"
    log_info "  nvim file.txt          # Edit a file"
    log_info "  vim file.txt           # Use 'vim' alias"
    log_info ""
    log_info "Basic commands:"
    log_info "  i                      # Enter insert mode"
    log_info "  ESC                    # Return to normal mode"
    log_info "  :w                     # Save file"
    log_info "  :q                     # Quit"
    log_info "  :wq or ZZ              # Save and quit"
    log_info "  :q!                    # Quit without saving"
    log_info ""
    log_info "Custom keybindings (leader = space):"
    log_info "  <space>w               # Quick save"
    log_info "  <space>q               # Quick quit"
    log_info "  <space>n               # Toggle line numbers"
    log_info "  <space><space>         # Clear search highlight"
    log_info "  Ctrl+h/j/k/l           # Navigate between splits"
    log_info ""
    log_info "Configuration: ~/.config/nvim/init.vim"
    log_info ""
    log_info "To install a plugin manager (vim-plug):"
    log_info "  sh -c 'curl -fLo \"\${XDG_DATA_HOME:-\$HOME/.local/share}\"/nvim/site/autoload/plug.vim --create-dirs \\"
    log_info "         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'"
else
    log_error "Neovim installation failed"
    exit 1
fi

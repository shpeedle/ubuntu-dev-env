#!/bin/bash

# Docker Installation Script
# Installs Docker Engine and Docker Compose using Docker's official repository

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[DOCKER]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[DOCKER]${NC} $1"
}

# Check if Docker is already installed
if command -v docker &> /dev/null; then
    CURRENT_VERSION=$(docker --version)
    log_warn "Docker is already installed (${CURRENT_VERSION})"
    read -p "Do you want to reinstall Docker? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping Docker installation"
        exit 0
    fi
fi

log_info "Installing Docker Engine..."

# Uninstall old versions (if any)
log_info "Removing old Docker versions (if any)..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Install prerequisites
log_info "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
log_info "Adding Docker GPG key..."
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
log_info "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose
log_info "Installing Docker Engine and Docker Compose..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    log_info "Docker installed successfully: ${DOCKER_VERSION}"

    # Check if docker compose plugin is installed
    if docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(docker compose version)
        log_info "Docker Compose installed: ${COMPOSE_VERSION}"
    fi

    # Add current user to docker group to run docker without sudo
    log_info "Adding current user to docker group..."
    sudo usermod -aG docker $USER

    log_warn "You need to log out and log back in (or restart) for docker group changes to take effect"
    log_info "After logging back in, you can run docker commands without sudo"

    # Start and enable Docker service
    log_info "Starting Docker service..."
    sudo systemctl start docker
    sudo systemctl enable docker

    # Test Docker installation (requires sudo until user logs out/in)
    log_info "Testing Docker installation..."
    if sudo docker run --rm hello-world &> /dev/null; then
        log_info "Docker is working correctly!"
    else
        log_warn "Docker test failed, but installation completed"
    fi

    log_info "Docker setup completed successfully"
else
    log_error "Docker installation failed"
    exit 1
fi

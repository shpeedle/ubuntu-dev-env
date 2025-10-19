#!/bin/bash

# Test script for running the Ansible playbook in a Docker container

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[TEST]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[TEST]${NC} $1"
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

echo ""
log_info "Ubuntu Development Environment - Docker Test"
log_info "=============================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    log_warn "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    log_warn "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Detect docker-compose command
if docker compose version &> /dev/null; then
    DOCKER_COMPOSE="docker compose"
else
    DOCKER_COMPOSE="docker-compose"
fi

log_step "Building test container..."
$DOCKER_COMPOSE -f docker-compose.test.yml build

log_step "Starting test container..."
$DOCKER_COMPOSE -f docker-compose.test.yml up -d

log_step "Installing Ansible in container..."
docker exec -u root ubuntu-dev-test bash -c "
    apt-get update &&
    apt-get install -y software-properties-common &&
    add-apt-repository --yes ppa:ansible/ansible &&
    apt-get update &&
    apt-get install -y ansible
"

log_step "Running Ansible playbook in container..."
echo ""
log_warn "Note: This will take several minutes..."
log_warn "Some installations (like Docker-in-Docker) may not work perfectly in containers"
echo ""

# Run the test playbook (simplified version for Docker)
docker exec -u testuser ubuntu-dev-test bash -c "
    cd /workspace
    ansible-playbook setup-test.yml
"

if [ $? -eq 0 ]; then
    echo ""
    log_info "✅ Ansible playbook completed successfully!"
    echo ""
    log_step "Verification - Checking installed tools..."

    # Verify installations
    docker exec -u testuser ubuntu-dev-test bash -c "
        echo '--- Build Tools ---'
        gcc --version 2>/dev/null | head -n1 || echo 'gcc: NOT FOUND'
        cmake --version 2>/dev/null | head -n1 || echo 'cmake: NOT FOUND'

        echo ''
        echo '--- CLI Tools ---'
        which fzf &>/dev/null && echo 'fzf: ✓' || echo 'fzf: NOT FOUND'
        which rg &>/dev/null && echo 'ripgrep: ✓' || echo 'ripgrep: NOT FOUND'
        which bat &>/dev/null && echo 'bat: ✓' || echo 'bat: NOT FOUND'
        which fd &>/dev/null && echo 'fd: ✓' || echo 'fd: NOT FOUND'
        which eza &>/dev/null && echo 'eza: ✓' || echo 'eza: NOT FOUND'

        echo ''
        echo '--- Programming Languages ---'
        python3 --version 2>/dev/null || echo 'python3: NOT FOUND'
        which uv &>/dev/null && uv --version 2>/dev/null || echo 'uv: NOT FOUND'
        go version 2>/dev/null || echo 'go: NOT FOUND'
        rustc --version 2>/dev/null || echo 'rustc: NOT FOUND'

        echo ''
        echo '--- Git Tools ---'
        gh --version 2>/dev/null | head -n1 || echo 'gh: NOT FOUND'
        lazygit --version 2>/dev/null || echo 'lazygit: NOT FOUND'

        echo ''
        echo '--- DevOps Tools ---'
        kubectl version --client 2>/dev/null | head -n1 || echo 'kubectl: NOT FOUND'
        tofu version 2>/dev/null | head -n1 || echo 'tofu: NOT FOUND'
        trivy --version 2>/dev/null | head -n1 || echo 'trivy: NOT FOUND'

        echo ''
        echo '--- Other Tools ---'
        tmux -V 2>/dev/null || echo 'tmux: NOT FOUND'
        nvim --version 2>/dev/null | head -n1 || echo 'nvim: NOT FOUND'
        code --version 2>/dev/null | head -n1 || echo 'code: NOT FOUND'
        which zsh &>/dev/null && echo 'zsh: ✓' || echo 'zsh: NOT FOUND'
    "

    echo ""
    log_info "To manually explore the container, run:"
    echo "  docker exec -it -u testuser ubuntu-dev-test /bin/bash"
    echo ""
    log_info "To stop and remove the test container, run:"
    echo "  $DOCKER_COMPOSE -f docker-compose.test.yml down"
    echo ""
else
    log_warn "❌ Ansible playbook failed!"
    echo ""
    log_info "To investigate, run:"
    echo "  docker exec -it -u testuser ubuntu-dev-test /bin/bash"
    echo ""
    log_info "To view logs:"
    echo "  docker logs ubuntu-dev-test"
    echo ""
fi

#!/bin/bash

# Kubernetes Tools Installation Script
# Installs kubectl

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[K8S]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[K8S]${NC} $1"
}

log_error() {
    echo -e "${RED}[K8S]${NC} $1"
}

log_info "Installing Kubernetes tools..."

# Install kubectl
log_info "Installing kubectl..."
if command -v kubectl &> /dev/null; then
    KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null | head -n1)
    log_warn "kubectl is already installed (${KUBECTL_VERSION})"
else
    # Add Kubernetes apt repository
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

    # Download the public signing key for the Kubernetes package repositories
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

    # Add the Kubernetes apt repository
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

    # Update apt package index and install kubectl
    sudo apt-get update
    sudo apt-get install -y kubectl

    if command -v kubectl &> /dev/null; then
        KUBECTL_VERSION=$(kubectl version --client --short 2>/dev/null || kubectl version --client 2>/dev/null | head -n1)
        log_info "kubectl installed: ${KUBECTL_VERSION}"
    fi
fi

# Add kubectl bash completion to zsh if installed
if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "kubectl completion zsh" "$HOME/.zshrc"; then
        log_info "Adding kubectl completion to zsh..."
        cat >> "$HOME/.zshrc" << 'EOF'

# kubectl completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion zsh)
    alias k='kubectl'
    complete -F __start_kubectl k
fi
EOF
        log_info "Added kubectl completion and alias 'k' to ~/.zshrc"
    fi
fi

# Add kubectl bash completion to bashrc if no zsh
if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
    if ! grep -q "kubectl completion bash" "$HOME/.bashrc"; then
        log_info "Adding kubectl completion to bash..."
        cat >> "$HOME/.bashrc" << 'EOF'

# kubectl completion
if command -v kubectl &> /dev/null; then
    source <(kubectl completion bash)
    alias k='kubectl'
    complete -F __start_kubectl k
fi
EOF
        log_info "Added kubectl completion and alias 'k' to ~/.bashrc"
    fi
fi

log_info ""
log_info "Kubernetes tools installation completed!"
log_info ""
log_info "kubectl commands:"
log_info "  kubectl version                # Check kubectl version"
log_info "  kubectl cluster-info           # Display cluster info"
log_info "  kubectl get nodes              # List cluster nodes"
log_info "  kubectl get pods               # List pods in default namespace"
log_info "  kubectl get pods -A            # List all pods in all namespaces"
log_info "  kubectl get services           # List services"
log_info "  kubectl describe pod <name>    # Get pod details"
log_info "  kubectl logs <pod>             # View pod logs"
log_info "  kubectl exec -it <pod> -- sh   # Execute shell in pod"
log_info "  kubectl apply -f <file>        # Apply configuration"
log_info "  kubectl delete -f <file>       # Delete resources"
log_info ""
log_info "Alias 'k' is available as shorthand for 'kubectl'"
log_info "Note: You need a Kubernetes cluster to use kubectl"

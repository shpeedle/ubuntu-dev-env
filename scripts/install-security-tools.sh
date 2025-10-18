#!/bin/bash

# Security Tools Installation Script
# Installs Trivy security scanner

set -e
set -o pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[SECURITY]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[SECURITY]${NC} $1"
}

log_error() {
    echo -e "${RED}[SECURITY]${NC} $1"
}

log_info "Installing security tools..."

# Install Trivy
log_info "Installing Trivy..."
if command -v trivy &> /dev/null; then
    TRIVY_VERSION=$(trivy --version | head -n1)
    log_warn "Trivy is already installed (${TRIVY_VERSION})"
else
    # Add Trivy repository
    sudo apt-get install -y wget apt-transport-https gnupg lsb-release

    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo gpg --dearmor -o /usr/share/keyrings/trivy.gpg

    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/trivy.list

    sudo apt-get update
    sudo apt-get install -y trivy

    if command -v trivy &> /dev/null; then
        TRIVY_VERSION=$(trivy --version | head -n1)
        log_info "Trivy installed: ${TRIVY_VERSION}"
    fi
fi

log_info ""
log_info "Security tools installation completed!"
log_info ""
log_info "Trivy commands:"
log_info ""
log_info "Container Image Scanning:"
log_info "  trivy image nginx:latest       # Scan Docker image"
log_info "  trivy image python:3.9         # Scan specific version"
log_info "  trivy image --severity HIGH,CRITICAL nginx  # Filter by severity"
log_info ""
log_info "Filesystem Scanning:"
log_info "  trivy fs .                     # Scan current directory"
log_info "  trivy fs /path/to/project      # Scan specific path"
log_info "  trivy fs --security-checks vuln,secret .  # Check for vulns and secrets"
log_info ""
log_info "Git Repository Scanning:"
log_info "  trivy repo https://github.com/user/repo    # Scan remote repo"
log_info "  trivy repo .                               # Scan local git repo"
log_info ""
log_info "Configuration Scanning:"
log_info "  trivy config .                 # Scan IaC files (Terraform, K8s, etc.)"
log_info "  trivy config --policy mypolicy.rego .      # Use custom policy"
log_info ""
log_info "Kubernetes Scanning:"
log_info "  trivy k8s --report summary     # Scan cluster (requires kubectl)"
log_info "  trivy k8s deployment/myapp     # Scan specific deployment"
log_info ""
log_info "SBOM (Software Bill of Materials):"
log_info "  trivy image --format cyclonedx nginx       # Generate SBOM"
log_info "  trivy sbom /path/to/sbom.json  # Scan existing SBOM"
log_info ""
log_info "Output Formats:"
log_info "  trivy image --format json nginx            # JSON output"
log_info "  trivy image --format sarif nginx           # SARIF for GitHub"
log_info "  trivy image -o report.html --format template --template '@contrib/html.tpl' nginx"
log_info ""
log_info "Trivy is a comprehensive security scanner for:"
log_info "  - Container images and filesystems"
log_info "  - Vulnerabilities (OS packages and language dependencies)"
log_info "  - IaC misconfigurations (Terraform, CloudFormation, Kubernetes, etc.)"
log_info "  - Secrets and sensitive information"
log_info "  - License scanning"

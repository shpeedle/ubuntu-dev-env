# Ubuntu Development Environment Setup

Automated installation scripts to configure a fresh Ubuntu desktop for software development.

## Overview

This repository contains a collection of bash scripts that automate the installation and configuration of essential development tools on Ubuntu. The scripts are designed to be idempotent, meaning they can be run multiple times safely.

## Installed Tools

- **Build Tools** - Essential compilation tools (gcc, g++, make, cmake)
- **Essential CLI Tools** - Modern replacements for common commands (fzf, ripgrep, bat, fd, eza, jq, yq, htop, tldr, ncdu)
- **Git** - Version control system
- **Git Tools** - GitHub CLI (gh), GitLab CLI (glab), and lazygit (terminal UI)
- **Python3** - Python programming language with pip and virtual environment support
- **UV (Astral)** - Extremely fast Python package installer and resolver
- **Node.js** - JavaScript runtime (LTS version) via nvm
- **Golang** - Go programming language
- **Rust** - Rust programming language with Cargo
- **Docker** - Container platform with Docker Compose
- **Kubernetes Tools** - kubectl for managing Kubernetes clusters
- **IaC Tools** - OpenTofu (Terraform alternative) and Terrascan (IaC security scanner)
- **Security Tools** - Trivy (comprehensive security scanner)
- **Ansible** - Automation and configuration management
- **AWS CLI** - Amazon Web Services command-line interface
- **Tmux** - Terminal multiplexer with custom configuration
- **Neovim** - Modern Vim-based text editor
- **Visual Studio Code** - Code editor with recommended extensions
- **Google Chrome** - Web browser from Google
- **Zsh** - Enhanced shell with Oh-My-Zsh framework

## Quick Start

### Run All Installations

To install all tools at once:

```bash
chmod +x setup.sh
./setup.sh
```

### Run Individual Installations

To install specific tools only:

```bash
chmod +x scripts/install-*.sh
./scripts/install-build-tools.sh
./scripts/install-cli-tools.sh
./scripts/install-git.sh
./scripts/install-git-tools.sh
./scripts/install-python3.sh
./scripts/install-uv.sh
./scripts/install-nodejs.sh
./scripts/install-golang.sh
./scripts/install-rust.sh
./scripts/install-docker.sh
./scripts/install-kubernetes-tools.sh
./scripts/install-iac-tools.sh
./scripts/install-security-tools.sh
./scripts/install-ansible.sh
./scripts/install-aws-cli.sh
./scripts/install-tmux.sh
./scripts/install-neovim.sh
./scripts/install-vscode.sh
./scripts/install-chrome.sh
./scripts/install-zsh.sh
```

## Installation Details

### Build Tools
- Installs build-essential package (gcc, g++, make, and other compilation tools)
- Installs cmake for cross-platform builds
- Essential for compiling C/C++ programs and building from source

### Essential CLI Tools
Modern replacements and enhancements for common command-line tools:
- **fzf** - Fuzzy finder for files and commands (Ctrl+R for history search)
- **ripgrep (rg)** - Blazingly fast grep alternative with better defaults
- **bat** - Cat with syntax highlighting and git integration
- **fd** - Simple, fast alternative to find
- **eza** - Modern ls replacement with icons and git status
- **jq** - Command-line JSON processor
- **yq** - Command-line YAML processor
- **htop** - Interactive process viewer
- **tldr** - Simplified man pages with practical examples
- **ncdu** - Disk usage analyzer with ncurses interface
- **ag** - The Silver Searcher (code searching tool)
- **tree** - Display directory structure
- Automatically adds helpful aliases to your shell configuration

### Git
- Installs latest Git from Ubuntu repositories
- Prompts for Git configuration (name and email) if not already configured
- Checks if Git is already installed before proceeding

### Git Tools
Enhanced Git workflows with official CLIs and terminal UI:
- **GitHub CLI (gh)** - Official GitHub command-line tool
  - Manage pull requests, issues, repos, and more from terminal
  - Authenticate and interact with GitHub without leaving your workflow
  - Create PRs, review code, manage releases
- **GitLab CLI (glab)** - Official GitLab command-line tool
  - Manage merge requests, issues, pipelines from terminal
  - Work with GitLab projects without browser context switching
  - Create MRs, manage CI/CD, view pipeline status
- **lazygit** - Terminal UI for git commands
  - Beautiful, intuitive interface for git operations
  - Stage files, create commits, manage branches visually
  - View diffs, logs, and stashes in interactive panels
  - Keyboard-driven workflow

### Python3
- Installs Python3, pip3, and python3-venv
- Installs Python development headers
- Upgrades pip to the latest version

### UV (Astral)
- Installs UV using the official installer
- Provides extremely fast Python package installation (10-100x faster than pip)
- Drop-in replacement for pip, pip-tools, and virtualenv
- Includes Python version management
- Supports project and script management

### Node.js
- Installs nvm (Node Version Manager)
- Uses nvm to install the latest Node.js LTS version
- Sets LTS as the default Node.js version
- Allows easy switching between Node.js versions
- Automatically configures nvm in ~/.bashrc

### Golang
- Downloads and installs Go 1.23.2 (configurable in script)
- Sets up GOPATH and adds Go to PATH
- Creates standard Go workspace directories

### Rust
- Installs Rust using rustup
- Installs rustfmt and clippy components
- Automatically configures Cargo environment

### Docker
- Installs Docker Engine from Docker's official repository
- Installs Docker Compose plugin
- Adds current user to docker group (requires logout/login to take effect)
- Starts and enables Docker service
- Runs test container to verify installation

### Kubernetes Tools
- **kubectl** - Kubernetes command-line tool
  - Manage Kubernetes clusters and applications
  - Install from official Kubernetes repositories
  - Includes bash/zsh completion
  - Adds convenient 'k' alias for kubectl

### Infrastructure as Code (IaC) Tools
- **OpenTofu** - Open-source Terraform alternative
  - Drop-in replacement for Terraform
  - Manage infrastructure with declarative configuration
  - Compatible with existing Terraform code
- **Terrascan** - Static code analyzer for IaC
  - Detect security vulnerabilities and compliance violations
  - Supports Terraform, Kubernetes, Helm, Dockerfile
  - 500+ policies for AWS, Azure, GCP, and more

### Security Tools
- **Trivy** - Comprehensive security scanner
  - Scan container images for vulnerabilities
  - Scan filesystems and Git repositories
  - Detect IaC misconfigurations
  - Find secrets and sensitive data
  - Generate SBOMs (Software Bill of Materials)
  - Support for multiple output formats

### Ansible
- Automation and configuration management platform
- Installed from official Ansible PPA
- Includes ansible-playbook and ansible-galaxy
- Creates basic configuration in ~/.ansible.cfg
- Sets up inventory directory
- No agents required - uses SSH

### AWS CLI
- Official Amazon Web Services command-line interface
- AWS CLI v2 installed from official source
- Manage AWS services from terminal
- Supports all AWS services
- Includes auto-completion
- Configuration stored in ~/.aws/

### Tmux
- Installs tmux terminal multiplexer
- Creates ~/.tmux.conf with sensible defaults
- Custom prefix key: Ctrl+a (instead of Ctrl+b)
- Mouse support enabled
- Intuitive pane splitting with | and -
- Helpful key bindings and 256 color support

### Neovim
- Modern, extensible Vim-based text editor
- Installed from unstable PPA for latest stable version
- Includes Python provider for plugin support
- Includes Node.js provider if npm is available
- Creates basic ~/.config/nvim/init.vim with sensible defaults
- Adds vim/vi aliases to use Neovim
- Features in default config:
  - Line numbers and relative numbers
  - Syntax highlighting and true color support
  - Smart indentation and search
  - Clipboard integration
  - Custom keybindings (space as leader key)
  - Split navigation with Ctrl+h/j/k/l

### Visual Studio Code
- Installs VSCode from Microsoft's official repository
- Installs recommended extensions:
  - Python (ms-python.python)
  - ESLint (dbaeumer.vscode-eslint)
  - Go (golang.go)
  - Rust Analyzer (rust-lang.rust-analyzer)
  - GitLens (eamodio.gitlens)
  - EditorConfig (EditorConfig.EditorConfig)

### Google Chrome
- Installs Google Chrome Stable from official Google repository
- Automatically receives updates through system package manager
- Supports all Chrome features and extensions
- Can be launched from application menu or command line
- Includes command-line flags for various modes (incognito, headless, etc.)

### Zsh
- Installs zsh shell
- Installs Oh-My-Zsh framework for enhanced functionality
- Installs popular plugins: zsh-autosuggestions, zsh-syntax-highlighting
- Pre-configured with useful aliases and functions
- Includes plugins for git, docker, python, node, rust, golang, kubectl, and more
- Automatically sets zsh as default shell (requires logout/login)
- Creates ~/.zshrc with optimized configuration

## Requirements

- Ubuntu Desktop (tested on Ubuntu 20.04+)
- sudo privileges
- Internet connection

## Post-Installation

After running the setup script, you should:

1. **Log out and log back in** (or restart your system) to:
   - Enable zsh as your default shell
   - Allow running Docker without sudo

2. After logging back in, verify installations:
   ```bash
   gcc --version
   cmake --version
   git --version
   python3 --version
   uv --version
   node --version
   go version
   rustc --version
   docker --version
   tmux -V
   code --version
   echo $SHELL  # Should show /usr/bin/zsh or similar
   ```

3. Start using tmux:
   ```bash
   tmux
   ```

4. Explore zsh features - autosuggestions and syntax highlighting work automatically!

## CLI Tools Quick Reference

The installed CLI tools enhance your command-line experience with modern replacements:

```bash
# File searching
rg "pattern"              # Search for text in files (replaces grep)
fd "filename"             # Find files by name (replaces find)
fzf                       # Fuzzy find files interactively
Ctrl+R                    # Fuzzy search command history

# File viewing
bat file.txt              # View file with syntax highlighting (replaces cat)
eza -la                   # List files with icons and git status (replaces ls)
eza -T                    # Tree view of directories

# Data processing
cat file.json | jq '.'    # Format and query JSON
cat file.yaml | yq '.'    # Format and query YAML

# System monitoring
htop                      # Interactive process viewer (replaces top)
ncdu                      # Analyze disk usage interactively (replaces du)

# Help and examples
tldr command              # Quick examples for any command (replaces man)
```

**Useful aliases automatically added:**
- `cat` → `bat` (with syntax highlighting)
- `ls` → `eza` (with icons)
- `find` → `fd` (faster find)
- `grep` → `rg` (faster grep)
- `top` → `htop` (interactive top)

## Git Tools Quick Reference

Streamline your Git and GitHub/GitLab workflows:

```bash
# GitHub CLI (gh)
gh auth login                 # Authenticate with GitHub
gh repo clone owner/repo      # Clone a repository
gh repo list                  # List your repositories
gh pr create                  # Create a pull request
gh pr list                    # List pull requests
gh pr view 123                # View PR #123
gh pr checkout 123            # Check out PR #123
gh pr merge 123               # Merge PR #123
gh issue create               # Create an issue
gh issue list                 # List issues
gh release create v1.0.0      # Create a release
gh workflow view              # View GitHub Actions workflows

# GitLab CLI (glab)
glab auth login               # Authenticate with GitLab
glab repo clone group/repo    # Clone a repository
glab repo list                # List your repositories
glab mr create                # Create a merge request
glab mr list                  # List merge requests
glab mr view 123              # View MR #123
glab mr checkout 123          # Check out MR #123
glab mr merge 123             # Merge MR #123
glab issue create             # Create an issue
glab issue list               # List issues
glab pipeline list            # List CI/CD pipelines
glab pipeline ci view         # View pipeline status

# lazygit
lazygit                       # Launch lazygit terminal UI
# Once in lazygit:
#   ↑↓ - Navigate files/commits
#   Space - Stage/unstage
#   c - Commit
#   P - Push
#   p - Pull
#   ? - Help menu
#   q - Quit
```

**First-time setup:**
```bash
gh auth login                 # Set up GitHub authentication
glab auth login               # Set up GitLab authentication
```

## DevOps & Cloud Tools Quick Reference

### Kubernetes (kubectl)
```bash
kubectl get pods              # List pods
kubectl get nodes             # List nodes
kubectl get services          # List services
kubectl describe pod <name>   # Get detailed info
kubectl logs <pod>            # View pod logs
kubectl exec -it <pod> -- sh  # Shell into pod
kubectl apply -f deployment.yaml  # Apply config
k get pods                    # Use 'k' alias
```

### Infrastructure as Code
```bash
# OpenTofu (Terraform alternative)
tofu init                     # Initialize directory
tofu plan                     # Preview changes
tofu apply                    # Apply changes
tofu destroy                  # Destroy infrastructure
tofu fmt                      # Format code
tofu validate                 # Validate configuration

# Terrascan (IaC security)
terrascan scan                # Scan current directory
terrascan scan -t aws         # Scan for AWS
terrascan scan -i terraform   # Scan Terraform files
```

### Security Scanning (Trivy)
```bash
# Container scanning
trivy image nginx:latest      # Scan Docker image
trivy image --severity HIGH,CRITICAL ubuntu  # Filter severity

# Filesystem scanning
trivy fs .                    # Scan current directory
trivy fs --security-checks vuln,secret /path  # Check vulns & secrets

# IaC scanning
trivy config .                # Scan IaC files
trivy k8s --report summary    # Scan Kubernetes cluster
```

### Ansible
```bash
# Configuration
ansible all -m ping           # Test connectivity
ansible-playbook site.yml     # Run playbook
ansible-playbook site.yml --check  # Dry run
ansible-galaxy install role   # Install role

# First-time setup
# Edit ~/.ansible/inventory/ to add hosts
```

### AWS CLI
```bash
# Configuration
aws configure                 # Set up credentials
aws configure --profile dev   # Set up named profile

# Common commands
aws s3 ls                     # List S3 buckets
aws ec2 describe-instances    # List EC2 instances
aws lambda list-functions     # List Lambda functions
aws sts get-caller-identity   # Check current identity
aws eks update-kubeconfig --name cluster  # Update kubectl config

# Use profiles
aws s3 ls --profile dev       # Use specific profile
```

## Customization

You can customize the installations by editing the individual scripts:

- **Node.js version**: Use nvm commands to install specific versions (e.g., `nvm install 18`, `nvm install 20`)
- **nvm version**: Edit `NVM_VERSION` variable in `scripts/install-nodejs.sh`
- **Go version**: Edit `GO_VERSION` variable in `scripts/install-golang.sh`
- **VSCode extensions**: Add/remove extensions in `scripts/install-vscode.sh`

## Safety Features

- All scripts check if tools are already installed
- Interactive prompts before reinstalling existing tools
- Error handling with `set -e` to exit on failures
- Color-coded output for better readability
- Idempotent - safe to run multiple times

## Troubleshooting

### Permission Issues
If you encounter permission errors, ensure you have sudo privileges:
```bash
sudo -v
```

### Docker Permission Denied
If you get "permission denied" when running docker commands:
```bash
# Log out and log back in, or restart your system
# Alternatively, for the current session only:
newgrp docker
```

### PATH Not Updated
If commands are not found after installation, source your bashrc:
```bash
source ~/.bashrc
```

Or restart your terminal.

### Script Execution Permission
If you get "Permission denied" when running scripts:
```bash
chmod +x setup.sh
chmod +x scripts/*.sh
```

## License

MIT License - Feel free to modify and distribute.

## Contributing

Feel free to submit issues or pull requests to improve these scripts.

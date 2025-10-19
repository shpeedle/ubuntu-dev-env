# Ubuntu Development Environment Setup

**Automated Ansible playbook to configure a fresh Ubuntu desktop for software development.**

## Overview

This repository uses Ansible to automate the installation and configuration of essential development tools on Ubuntu. The playbook is **idempotent** - you can run it multiple times safely.

## Installed Tools

- **Build Tools** - gcc, g++, make, cmake
- **Essential CLI Tools** - fzf, ripgrep, bat, fd, eza, jq, yq, htop, tldr, ncdu
- **Nerd Fonts** - JetBrainsMono Nerd Font (for terminal icons)
- **Git** - Version control system
- **Git Tools** - GitHub CLI (gh), lazygit
- **Python3** - Python with pip, venv, and development headers
- **UV (Astral)** - Ultra-fast Python package installer and resolver
- **Node.js** - JavaScript runtime (LTS version via nvm)
- **Golang** - Go programming language
- **Rust** - Rust programming language with Cargo
- **Docker** - Container platform with Docker Compose
- **Kubernetes Tools** - kubectl
- **IaC Tools** - OpenTofu (Terraform alternative), Terrascan
- **Security Tools** - Trivy (vulnerability scanner)
- **Ansible** - Automation and configuration management (installed by bootstrap)
- **AWS CLI** - Amazon Web Services CLI
- **Tmux** - Terminal multiplexer with custom config
- **Neovim** - Modern Vim-based text editor with config
- **Visual Studio Code** - Code editor with recommended extensions
- **Google Chrome** - Web browser
- **Zsh** - Enhanced shell with Oh-My-Zsh, plugins, and aliases

## Quick Start

### Option 1: Bootstrap Script (Recommended)

The easiest way - automatically installs Ansible if needed and runs the playbook:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

You'll be prompted for your sudo password.

### Option 2: Manual Ansible Installation

If you prefer to install Ansible manually:

```bash
# Install Ansible
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

# Run the playbook
ansible-playbook setup.yml --ask-become-pass
```

## Post-Installation

After running the setup, you should:

1. **Log out and log back in** (or restart your system) to:
   - Enable zsh as your default shell
   - Allow running Docker without sudo

2. **Configure your terminal to use the Nerd Font**:
   - The playbook installs **JetBrainsMono Nerd Font** which provides icon support
   - You need to configure your terminal emulator to use this font
   - **GNOME Terminal**: Edit → Preferences → Profile → Text → Custom font → Select "JetBrainsMono Nerd Font"
   - **Other terminals**: Look for font settings and select "JetBrainsMono Nerd Font" or "JetBrainsMono NF"
   - If icons still don't display, you may need to restart your terminal

3. After logging back in, verify installations:
   ```bash
   gcc --version
   git --version
   python3 --version
   node --version
   go version
   rustc --version
   docker --version
   kubectl version --client
   code --version
   echo $SHELL  # Should show /usr/bin/zsh
   ```

4. Start using your new tools!

## Customization

### Modify Installed Tools

Edit `setup.yml` to customize what gets installed. The playbook is organized into sections with clear comments.

### Change Versions

Update version variables at the top of `setup.yml`:

```yaml
vars:
  go_version: "1.23.2"
  nvm_version: "v0.40.1"
```

### Skip Specific Tools

Use Ansible tags to install only specific tools:

```bash
# List available tags
ansible-playbook setup.yml --list-tags

# Install only specific tools
ansible-playbook setup.yml --tags "docker,python" --ask-become-pass

# Skip specific tools
ansible-playbook setup.yml --skip-tags "vscode,chrome" --ask-become-pass
```

## CLI Tools Quick Reference

The playbook installs modern CLI replacements with helpful aliases:

```bash
# File searching
rg "pattern"              # Search for text in files (faster grep)
fd "filename"             # Find files by name (faster find)
fzf                       # Fuzzy find files interactively
Ctrl+R                    # Fuzzy search command history

# File viewing
bat file.txt              # View file with syntax highlighting
eza -la                   # List files with icons and git status
eza -T                    # Tree view of directories

# Data processing
cat file.json | jq '.'    # Format and query JSON
cat file.yaml | yq '.'    # Format and query YAML

# System monitoring
htop                      # Interactive process viewer
ncdu                      # Analyze disk usage interactively

# Help and examples
tldr command              # Quick examples for any command
```

**Aliases automatically configured:**
- `cat` → `bat` (with syntax highlighting)
- `ls` → `eza` (with icons)
- `find` → `fd` (faster find)
- `grep` → `rg` (faster grep)
- `top` → `htop` (interactive top)
- `k` → `kubectl` (Kubernetes shortcut)

## Git Tools Quick Reference

Streamline your Git and GitHub workflows:

```bash
# GitHub CLI (gh)
gh auth login                 # Authenticate with GitHub
gh repo list                  # List your repositories
gh pr create                  # Create a pull request
gh pr list                    # List pull requests
gh pr checkout 123            # Check out PR #123
gh pr merge 123               # Merge PR #123
gh issue create               # Create an issue
gh issue list                 # List issues
gh release create v1.0.0      # Create a release

# lazygit
lazygit                       # Launch lazygit terminal UI
# Once in lazygit:
#   ↑↓ - Navigate files/commits
#   Space - Stage/unstage
#   c - Commit
#   P - Push
#   p - Pull
#   ? - Help menu
```

## DevOps & Cloud Tools Quick Reference

```bash
# Kubernetes (kubectl)
kubectl get pods              # List pods
k get pods                    # Same with alias
kubectl logs <pod>            # View pod logs

# OpenTofu (Terraform alternative)
tofu init                     # Initialize directory
tofu plan                     # Preview changes
tofu apply                    # Apply changes

# Terrascan (IaC security)
terrascan scan                # Scan current directory
terrascan scan -t aws         # Scan for AWS

# Trivy (Security scanning)
trivy image nginx:latest      # Scan Docker image
trivy fs .                    # Scan current directory
trivy config .                # Scan IaC files

# AWS CLI
aws configure                 # Set up credentials
aws s3 ls                     # List S3 buckets
aws ec2 describe-instances    # List EC2 instances

# Docker
docker ps                     # List running containers
dps                          # Same with alias
docker-compose up -d          # Start services
dcup                         # Same with alias
```

## Ansible Advantages

This setup uses Ansible instead of plain bash scripts because:

- ✅ **Idempotent by design** - Run it many times safely
- ✅ **Declarative** - Describe *what* you want, not *how* to get it
- ✅ **Built-in modules** - Robust handling of packages, files, users, etc.
- ✅ **Readable YAML** - Easier to understand and modify than bash
- ✅ **Better error handling** - Ansible handles failures gracefully
- ✅ **Industry standard** - Well-tested and widely used

## Testing with Docker

You can test the playbook in a Docker container before running it on your actual system:

```bash
chmod +x test-in-docker.sh
./test-in-docker.sh
```

This will:
1. Build an Ubuntu 24.04 Docker container
2. Install Ansible inside the container
3. Run the playbook (simplified version without Docker/systemd)
4. Verify all tools were installed correctly

**Note:** The Docker test uses `setup-test.yml` which skips Docker-in-Docker and systemd services.

To manually explore the test container:
```bash
docker exec -it -u testuser ubuntu-dev-test /bin/bash
```

To clean up:
```bash
docker compose -f docker-compose.test.yml down
```

## Requirements

- Ubuntu Desktop (tested on Ubuntu 20.04+)
- sudo privileges
- Internet connection

## Safety Features

- ✅ Idempotent - safe to run multiple times
- ✅ Non-destructive - doesn't remove existing configurations
- ✅ Ansible's built-in error handling
- ✅ No hardcoded credentials or personal information
- ✅ Safe to make public

## Troubleshooting

### Icons Not Displaying (Blank Boxes)
If you see blank/empty boxes instead of icons when using `ls` or `eza`:
```bash
# 1. Verify Nerd Font is installed
fc-list | grep -i "JetBrains"

# 2. Configure your terminal to use the Nerd Font
# GNOME Terminal: Edit → Preferences → Profile → Text → Custom font
# Select "JetBrainsMono Nerd Font" or "JetBrainsMono NF"

# 3. Restart your terminal
# Close and reopen your terminal window

# 4. Test icon display
ls  # Should show icons properly
```

### Permission Issues
```bash
sudo -v  # Verify you have sudo privileges
```

### Docker Permission Denied
After installation, log out and log back in. Alternatively:
```bash
newgrp docker  # For current session only
```

### PATH Not Updated
```bash
source ~/.zshrc  # Reload shell configuration
```

### Ansible Issues
```bash
ansible --version  # Verify Ansible is installed
ansible-playbook setup.yml --check  # Dry run to test
```

## License

MIT License - Feel free to modify and distribute.

## Contributing

Feel free to submit issues or pull requests to improve this playbook.

#!/bin/bash

# AWS CLI Installation Script
# Installs AWS CLI v2

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log_info() {
    echo -e "${GREEN}[AWS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[AWS]${NC} $1"
}

log_error() {
    echo -e "${RED}[AWS]${NC} $1"
}

log_info "Installing AWS CLI..."

# Check if AWS CLI is already installed
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version)
    log_warn "AWS CLI is already installed (${AWS_VERSION})"
    read -p "Do you want to reinstall/update AWS CLI? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Skipping AWS CLI installation"
        exit 0
    fi
fi

log_info "Installing AWS CLI v2..."

# Determine architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        AWS_ARCH="x86_64"
        ;;
    aarch64)
        AWS_ARCH="aarch64"
        ;;
    *)
        log_error "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Download AWS CLI v2
log_info "Downloading AWS CLI v2 for ${AWS_ARCH}..."
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o "awscliv2.zip"

# Install unzip if not already installed
if ! command -v unzip &> /dev/null; then
    log_info "Installing unzip..."
    sudo apt-get install -y unzip
fi

# Unzip the installer
unzip -q awscliv2.zip

# Run the installer
log_info "Running AWS CLI installer..."
sudo ./aws/install --update

# Clean up
rm -rf awscliv2.zip aws

# Verify installation
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version)
    log_info "AWS CLI installed: ${AWS_VERSION}"

    log_info ""
    log_info "AWS CLI installation completed!"
    log_info ""
    log_info "Getting started:"
    log_info "  aws configure              # Configure AWS credentials"
    log_info "  aws configure --profile myprofile  # Configure named profile"
    log_info ""
    log_info "Common AWS CLI commands:"
    log_info ""
    log_info "S3:"
    log_info "  aws s3 ls                  # List S3 buckets"
    log_info "  aws s3 ls s3://bucket      # List bucket contents"
    log_info "  aws s3 cp file.txt s3://bucket/  # Upload file"
    log_info "  aws s3 cp s3://bucket/file.txt .  # Download file"
    log_info "  aws s3 sync . s3://bucket/ # Sync directory"
    log_info ""
    log_info "EC2:"
    log_info "  aws ec2 describe-instances # List EC2 instances"
    log_info "  aws ec2 start-instances --instance-ids i-xxx"
    log_info "  aws ec2 stop-instances --instance-ids i-xxx"
    log_info "  aws ec2 describe-security-groups  # List security groups"
    log_info ""
    log_info "IAM:"
    log_info "  aws iam list-users         # List IAM users"
    log_info "  aws iam list-roles         # List IAM roles"
    log_info "  aws iam get-user           # Get current user info"
    log_info ""
    log_info "Lambda:"
    log_info "  aws lambda list-functions  # List Lambda functions"
    log_info "  aws lambda invoke --function-name myfunction output.json"
    log_info ""
    log_info "ECS/EKS:"
    log_info "  aws ecs list-clusters      # List ECS clusters"
    log_info "  aws eks list-clusters      # List EKS clusters"
    log_info "  aws eks update-kubeconfig --name mycluster  # Update kubectl config"
    log_info ""
    log_info "CloudFormation:"
    log_info "  aws cloudformation list-stacks  # List stacks"
    log_info "  aws cloudformation describe-stacks --stack-name mystack"
    log_info ""
    log_info "SSM (Systems Manager):"
    log_info "  aws ssm get-parameter --name /path/to/param"
    log_info "  aws ssm start-session --target i-xxx  # SSH via SSM"
    log_info ""
    log_info "Useful options:"
    log_info "  --profile myprofile        # Use specific profile"
    log_info "  --region us-west-2         # Override region"
    log_info "  --output json              # JSON output"
    log_info "  --output table             # Table output"
    log_info "  --query 'expression'       # Filter output with JMESPath"
    log_info ""
    log_info "Configuration files:"
    log_info "  ~/.aws/credentials         # AWS credentials"
    log_info "  ~/.aws/config              # AWS CLI configuration"
    log_info ""
    log_info "Run 'aws configure' to set up your AWS credentials"
else
    log_error "AWS CLI installation failed"
    exit 1
fi

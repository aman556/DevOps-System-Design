#!/usr/bin/env bash

set -e

# Check for required commands
for cmd in curl unzip; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: '$cmd' is not installed. Please install it and rerun this script."
        exit 1
    fi
done

# Find or create temp dir
if command -v mktemp &> /dev/null; then
    TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'tf-tmp')
else
    TMP_DIR="/tmp/tf-tmp-$$"
    mkdir -p "$TMP_DIR"
fi

# Detect OS
OS="$(uname | tr '[:upper:]' '[:lower:]')"
if [[ "$OS" == "darwin" ]]; then
    PLATFORM="darwin"
elif [[ "$OS" == "linux" ]]; then
    PLATFORM="linux"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64 | amd64)
        ARCH="amd64"
        ;;
    arm64 | aarch64)
        ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Get the latest stable version (skip alpha, beta, rc)
LATEST_VERSION=$(curl -s https://releases.hashicorp.com/terraform/ \
  | grep -Eo '<a href="/terraform/[0-9]+\.[0-9]+\.[0-9]+/">terraform_[0-9]+\.[0-9]+\.[0-9]+</a>' \
  | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' \
  | sort -V | tail -n 1)

if [[ -z "$LATEST_VERSION" ]]; then
    echo "Could not find latest stable Terraform version."
    exit 1
fi

echo "Installing Terraform $LATEST_VERSION for $PLATFORM-$ARCH..."

TERRAFORM_ZIP="terraform_${LATEST_VERSION}_${PLATFORM}_${ARCH}.zip"
DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${LATEST_VERSION}/${TERRAFORM_ZIP}"

cd "$TMP_DIR"
echo "Downloading $DOWNLOAD_URL..."
curl -fsSLO "$DOWNLOAD_URL"

# Verify the file is a zip
if ! file "$TERRAFORM_ZIP" | grep -qi 'zip archive'; then
    echo "Error: Downloaded file is not a valid zip archive. Download may have failed."
    rm -rf "$TMP_DIR"
    exit 1
fi

echo "Unzipping $TERRAFORM_ZIP..."
unzip -o "$TERRAFORM_ZIP"

echo "Installing terraform binary..."
sudo mv terraform /usr/local/bin/
sudo chmod +x /usr/local/bin/terraform

cd /
rm -rf "$TMP_DIR"

echo "Terraform installed successfully!"
terraform version

#!/usr/bin/env bash
set -e

# Detect OS
OS="$(uname | tr '[:upper:]' '[:lower:]')"
case "$OS" in
  linux)   PLATFORM="linux" ;;
  darwin)  PLATFORM="macos" ;;
  msys*|cygwin*|mingw*) PLATFORM="windows" ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64|amd64) ARCH="x86_64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

echo "Detected platform: $PLATFORM, architecture: $ARCH"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if [[ "$PLATFORM" == "linux" ]]; then
  if [[ "$ARCH" == "x86_64" ]]; then
    URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  else
    URL="https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip"
  fi
  curl -fsSLO "$URL"
  ZIP="${URL##*/}"
  unzip -q "$ZIP"
  sudo ./aws/install --update
elif [[ "$PLATFORM" == "macos" ]]; then
  if [[ "$ARCH" == "x86_64" ]]; then
    URL="https://awscli.amazonaws.com/AWSCLIV2.pkg"
  else
    URL="https://awscli.amazonaws.com/AWSCLIV2.pkg"
  fi
  curl -fsSLO "$URL"
  sudo installer -pkg "${URL##*/}" -target /
elif [[ "$PLATFORM" == "windows" ]]; then
  echo "Please download and run the Windows installer from:"
  echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
  exit 1
fi

cd /
rm -rf "$TMP_DIR"

echo "AWS CLI installed! Version:"
aws --version

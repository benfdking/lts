#!/bin/sh
set -e

# Universal LTS installer script
# Detects OS and architecture, downloads the appropriate binary

GITHUB_REPO="benfdking/lts"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     OS="Linux";;
    Darwin*)    OS="Darwin";;
    MINGW*|MSYS*|CYGWIN*) OS="Windows";;
    *)          echo "Unsupported OS: $OS"; exit 1;;
esac

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64|amd64)   ARCH="x86_64";;
    aarch64|arm64)  ARCH="arm64";;
    *)              echo "Unsupported architecture: $ARCH"; exit 1;;
esac

# Get latest release version
echo "Fetching latest release..."
LATEST_VERSION=$(curl -s "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Failed to fetch latest version"
    exit 1
fi

echo "Installing lts ${LATEST_VERSION}..."

# Construct download URL
if [ "$OS" = "Windows" ]; then
    ARCHIVE="lts_${OS}_${ARCH}.zip"
    DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/${LATEST_VERSION}/${ARCHIVE}"
else
    ARCHIVE="lts_${OS}_${ARCH}.tar.gz"
    DOWNLOAD_URL="https://github.com/${GITHUB_REPO}/releases/download/${LATEST_VERSION}/${ARCHIVE}"
fi

# Create temporary directory
TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Download archive
echo "Downloading from ${DOWNLOAD_URL}..."
curl -L -o "${TMP_DIR}/${ARCHIVE}" "${DOWNLOAD_URL}"

# Extract archive
cd "$TMP_DIR"
if [ "$OS" = "Windows" ]; then
    unzip -q "${ARCHIVE}"
    BINARY="lts.exe"
else
    tar -xzf "${ARCHIVE}"
    BINARY="lts"
fi

# Install binary
echo "Installing to ${INSTALL_DIR}..."
if [ -w "$INSTALL_DIR" ]; then
    mv "$BINARY" "${INSTALL_DIR}/"
    chmod +x "${INSTALL_DIR}/${BINARY}"
else
    echo "Requesting elevated permissions to install to ${INSTALL_DIR}..."
    sudo mv "$BINARY" "${INSTALL_DIR}/"
    sudo chmod +x "${INSTALL_DIR}/${BINARY}"
fi

echo "✓ lts ${LATEST_VERSION} installed successfully!"
echo "Run 'lts --help' to get started."

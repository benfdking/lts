#!/bin/sh
set -e

# Universal LTS installer script
# Detects OS and architecture, downloads the appropriate binary

GITHUB_REPO="benfdking/lts"
INSTALL_DIR="${INSTALL_DIR:-/usr/local/bin}"
SHARE_DIR="${SHARE_DIR:-/usr/local/share/lts}"

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

# Download wrapper script
echo "Downloading wrapper script..."
WRAPPER_URL="https://raw.githubusercontent.com/${GITHUB_REPO}/main/lts-wrapper.sh"
curl -fsSL -o "lts-wrapper.sh" "${WRAPPER_URL}" || {
    echo "Warning: Failed to download wrapper script. Continuing with binary installation only."
    WRAPPER_DOWNLOADED=false
}
WRAPPER_DOWNLOADED=true

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

# Install wrapper script if downloaded
if [ "$WRAPPER_DOWNLOADED" = true ]; then
    echo "Installing wrapper script to ${SHARE_DIR}..."
    if [ -w "$(dirname "$SHARE_DIR")" ] || [ -w "$SHARE_DIR" ] 2>/dev/null; then
        mkdir -p "$SHARE_DIR"
        cp "lts-wrapper.sh" "${SHARE_DIR}/"
        chmod +x "${SHARE_DIR}/lts-wrapper.sh"
    else
        echo "Requesting elevated permissions to install wrapper..."
        sudo mkdir -p "$SHARE_DIR"
        sudo cp "lts-wrapper.sh" "${SHARE_DIR}/"
        sudo chmod +x "${SHARE_DIR}/lts-wrapper.sh"
    fi
fi

echo
echo "✓ lts ${LATEST_VERSION} installed successfully!"
echo

# Show usage instructions
if [ "$WRAPPER_DOWNLOADED" = true ]; then
    echo "To enable interactive command execution, add this to your shell config:"
    echo

    # Detect shell and show appropriate instructions
    CURRENT_SHELL=$(basename "$SHELL" 2>/dev/null || echo "bash")
    case "$CURRENT_SHELL" in
        bash)
            echo "  # For Bash (~/.bashrc):"
            echo "  source ${SHARE_DIR}/lts-wrapper.sh"
            ;;
        zsh)
            echo "  # For Zsh (~/.zshrc):"
            echo "  source ${SHARE_DIR}/lts-wrapper.sh"
            ;;
        fish)
            echo "  # For Fish (~/.config/fish/config.fish):"
            echo "  source ${SHARE_DIR}/lts-wrapper.sh"
            ;;
        *)
            echo "  # Add to your shell config file:"
            echo "  source ${SHARE_DIR}/lts-wrapper.sh"
            ;;
    esac

    echo
    echo "Then reload your shell or run: source ~/.bashrc (or ~/.zshrc)"
    echo
fi

echo "Run 'lts init' to configure your LLM provider."
echo "Run 'lts --help' for more information."

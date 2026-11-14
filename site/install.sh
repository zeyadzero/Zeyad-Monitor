#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="https://zeyadzero.github.io/Zeyad-Monitor"
KEY_URL="$REPO_URL/key.gpg"
KEYRING="/etc/apt/keyrings/zeyad-monitor.gpg"
SOURCE_FILE="/etc/apt/sources.list.d/zeyad-monitor.list"
FINGERPRINT="D3E76CD1541772F410F71194273439D3D720600E"

echo "======================================"
echo "       Zeyad Monitor Installer"
echo "======================================"

if [[ $EUID -ne 0 ]]; then
    echo "ERROR: Run this installer as root."
    exit 1
fi

if [[ ! -f /etc/os-release ]] || ! grep -Eqi '^(ID|ID_LIKE)=.*(ubuntu|debian|linuxmint)' /etc/os-release; then
    echo "ERROR: Supported systems: Ubuntu, Debian and Linux Mint."
    exit 1
fi

for cmd in curl gpg apt-get; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command not found: $cmd"
        exit 1
    fi
done

TMP_KEY="$(mktemp)"
trap 'rm -f "$TMP_KEY"' EXIT

echo "[1/4] Downloading repository signing key..."
curl -fsSL "$KEY_URL" -o "$TMP_KEY"

echo "[2/4] Verifying GPG fingerprint..."
ACTUAL_FINGERPRINT="$(gpg --show-keys --with-colons "$TMP_KEY" | awk -F: '$1=="fpr" {print $10; exit}')"

if [[ "$ACTUAL_FINGERPRINT" != "$FINGERPRINT" ]]; then
    echo "ERROR: GPG fingerprint verification failed!"
    echo "Expected: $FINGERPRINT"
    echo "Received: $ACTUAL_FINGERPRINT"
    exit 1
fi

echo "GPG fingerprint verified successfully."

echo "[3/4] Configuring APT repository..."
install -d -m 0755 /etc/apt/keyrings
install -m 0644 "$TMP_KEY" "$KEYRING"

echo "deb [signed-by=$KEYRING] $REPO_URL stable main" > "$SOURCE_FILE"
chmod 0644 "$SOURCE_FILE"

echo "[4/4] Updating package lists..."
apt-get update

echo "Installing Zeyad Monitor..."
apt-get install -y zeyad-monitor

echo
echo "======================================"
echo " Zeyad Monitor installed successfully!"
echo "======================================"

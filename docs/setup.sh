#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="https://zeyadzero.github.io/Zeyad-Monitor"
KEYRING="/etc/apt/keyrings/zeyad-monitor.gpg"
SOURCE_FILE="/etc/apt/sources.list.d/zeyad-monitor.list"
FINGERPRINT="D3E76CD1541772F410F71194273439D3D720600E"

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo."
    exit 1
fi

source /etc/os-release
if ! grep -Eqi 'ubuntu|debian|linuxmint' <<< "${ID:-} ${ID_LIKE:-}"; then
    echo "Supported systems: Ubuntu, Debian and Linux Mint."
    exit 1
fi

for cmd in curl gpg apt-get; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing required command: $cmd"
        exit 1
    }
done

TMP_KEY="$(mktemp)"
trap 'rm -f "$TMP_KEY"' EXIT

echo "[1/3] Downloading GPG key..."
curl -fsSL "$REPO_URL/key.gpg" -o "$TMP_KEY"

echo "[2/3] Verifying GPG fingerprint..."
ACTUAL="$(gpg --show-keys --with-colons "$TMP_KEY" |
    awk -F: '$1=="fpr" {print $10; exit}')"

if [[ "$ACTUAL" != "$FINGERPRINT" ]]; then
    echo "GPG fingerprint verification failed!"
    exit 1
fi

echo "[3/3] Configuring APT..."
install -d -m 0755 /etc/apt/keyrings
install -m 0644 "$TMP_KEY" "$KEYRING"

echo "deb [signed-by=$KEYRING] $REPO_URL stable main" > "$SOURCE_FILE"
chmod 0644 "$SOURCE_FILE"

apt-get update

echo
echo "Repository configured successfully!"
echo "Install using: sudo apt install zeyad-monitor"

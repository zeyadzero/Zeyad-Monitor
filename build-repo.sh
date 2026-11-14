#!/usr/bin/env bash
# Builds a signed APT repository in ./docs from the .deb files in ./debs
# Usage:  GPG_KEY=<key id or email> [GPG_PASSPHRASE=...] ./build-repo.sh
set -euo pipefail
cd "$(dirname "$0")"

: "${GPG_KEY:?Set GPG_KEY to your signing key id or email}"
SUITE="${SUITE:-stable}"
COMP="main"
OUT="docs"

shopt -s nullglob
debs=(debs/*.deb)
[ ${#debs[@]} -gt 0 ] || { echo "No .deb files in ./debs"; exit 1; }

rm -rf "$OUT"
mkdir -p "$OUT/pool/$COMP" "$OUT/dists/$SUITE/$COMP/binary-all"
cp "${debs[@]}" "$OUT/pool/$COMP/"

# --- package index (arch-independent "all" packages)
( cd "$OUT" && apt-ftparchive packages "pool/$COMP" > "dists/$SUITE/$COMP/binary-all/Packages" )
gzip -9kf "$OUT/dists/$SUITE/$COMP/binary-all/Packages"
# amd64/arm64/i386 machines also look for their own index: provide the same list
for arch in amd64 arm64 i386; do
  mkdir -p "$OUT/dists/$SUITE/$COMP/binary-$arch"
  cp "$OUT/dists/$SUITE/$COMP/binary-all/Packages" "$OUT/dists/$SUITE/$COMP/binary-all/Packages.gz" \
     "$OUT/dists/$SUITE/$COMP/binary-$arch/"
done

# --- Release file
cat > /tmp/apt-release.conf <<CONF
APT::FTPArchive::Release::Origin "Zeyad Monitor";
APT::FTPArchive::Release::Label "Zeyad Monitor";
APT::FTPArchive::Release::Suite "$SUITE";
APT::FTPArchive::Release::Codename "$SUITE";
APT::FTPArchive::Release::Architectures "all amd64 arm64 i386";
APT::FTPArchive::Release::Components "$COMP";
APT::FTPArchive::Release::Description "Zeyad Monitor APT repository";
CONF
apt-ftparchive -c /tmp/apt-release.conf release "$OUT/dists/$SUITE" > /tmp/Release.new
mv /tmp/Release.new "$OUT/dists/$SUITE/Release"

# --- sign
GPG_OPTS=(--yes --default-key "$GPG_KEY")
if [ -n "${GPG_PASSPHRASE:-}" ]; then
  PF="$(mktemp)"; chmod 600 "$PF"; printf '%s' "$GPG_PASSPHRASE" > "$PF"
  GPG_OPTS+=(--passphrase-file "$PF")
fi
gpg "${GPG_OPTS[@]}" --clearsign -o "$OUT/dists/$SUITE/InRelease" "$OUT/dists/$SUITE/Release"
gpg "${GPG_OPTS[@]}" -abs      -o "$OUT/dists/$SUITE/Release.gpg" "$OUT/dists/$SUITE/Release"
[ -n "${PF:-}" ] && rm -f "$PF"

# --- public key for users (binary .gpg works with signed-by=)
gpg --batch --yes --export "$GPG_KEY" > "$OUT/key.gpg"
gpg --batch --yes --armor --export "$GPG_KEY" > "$OUT/key.asc"
touch "$OUT/.nojekyll"
cp site/index.html "$OUT/index.html"
cp site/setup.sh "$OUT/setup.sh"
cp site/install.sh "$OUT/install.sh"
cp site/uninstall.sh "$OUT/uninstall.sh"
cp README.md "$OUT/README.md" 2>/dev/null || true
echo "Repository ready in ./$OUT  ($(ls "$OUT/pool/$COMP" | wc -l) package file(s))"

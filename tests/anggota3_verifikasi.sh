#!/usr/bin/env bash
set -u

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERIFY_SCRIPT="$REPO_DIR/scripts/verifikasi.sh"
WORK_DIR="/tmp/pso-a3-verifikasi"

rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR/payload"
echo "dummy backup payload for SIAKAD" > "$WORK_DIR/payload/data.txt"

ARCHIVE="$WORK_DIR/backup_siakad_20261123_200000.tar.gz"
SHA_FILE="${ARCHIVE}.sha256"
TAMPERED="$WORK_DIR/backup_siakad_tampered.tar.gz"

tar -czf "$ARCHIVE" -C "$WORK_DIR/payload" .
(cd "$WORK_DIR" && sha256sum "$(basename "$ARCHIVE")" > "$(basename "$SHA_FILE")")

echo "[A3-P1] Verifikasi arsip asli (harapan: exit 0)"
"$VERIFY_SCRIPT" "$ARCHIVE" "$SHA_FILE"
echo "exit status: $?"
echo

cp "$ARCHIVE" "$TAMPERED"
echo "tampered byte" >> "$TAMPERED"
# Copy checksum file pointing to the tampered archive name to test mismatch
sed "s/$(basename "$ARCHIVE")/$(basename "$TAMPERED")/" "$SHA_FILE" > "$WORK_DIR/tampered.sha256"

echo "[A3-N1] Verifikasi arsip yang diubah (harapan: exit 4)"
"$VERIFY_SCRIPT" "$TAMPERED" "$WORK_DIR/tampered.sha256"
echo "exit status: $?"
echo

rm -rf "$WORK_DIR"
echo "(kondisi uji dibersihkan)"

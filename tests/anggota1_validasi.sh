#!/usr/bin/env bash
# Uji skenario Anggota 1 (validasi). Menjalankan sebagai user biasa dan root.
cd "$(dirname "$0")/.." || exit 1
S=./scripts/validasi.sh
SUMBER="$HOME/pso-data/sumber"
TUJUAN="$HOME/pso-data/backup"

jalan() {
  echo "\$ $*"
  "$@" 2>&1
  echo "exit status: $?"
  echo
}

echo "[A1-P1] sumber dan tujuan valid (harapan: 0)"
jalan $S "$SUMBER" "$TUJUAN"

echo "[A1-N1] sumber tidak ada (harapan: 2)"
jalan $S /tidak/ada "$TUJUAN"

echo "[A1-N2] tanpa parameter (harapan: 2)"
jalan $S

echo "[A1-N3] sumber berupa file (harapan: 2)"
jalan $S "$SUMBER/siakad_dummy/index.html" "$TUJUAN"

echo "[A1-N4] sumber kosong (harapan: 2)"
mkdir -p /tmp/pso-kosong
jalan $S /tmp/pso-kosong "$TUJUAN"

echo "[A1-N5] tujuan tidak ada (harapan: 2)"
jalan $S "$SUMBER" /tidak/ada/tujuan

echo "[A1-N6] sumber tanpa izin akses (harapan: 2)"
mkdir -p /tmp/pso-terkunci && touch /tmp/pso-terkunci/file.txt
chmod 000 /tmp/pso-terkunci
jalan $S /tmp/pso-terkunci "$TUJUAN"

# Pembersihan kondisi uji
chmod 755 /tmp/pso-terkunci
rm -rf /tmp/pso-terkunci /tmp/pso-kosong
echo "(kondisi uji dibersihkan)"

#!/usr/bin/env bash
# Uji skenario Anggota 5 (lock, log, laporan, Docker).
cd "$(dirname "$0")/.." || exit 1

jalan() {
  echo "\$ $*"
  "$@" 2>&1
  echo "exit status: $?"
  echo
}

export LOCK_FILE=/tmp/pso-uji.lock
export LOG_FILE="$PWD/output/backup.log"
export LAPORAN_FILE="$PWD/output/laporan.txt"
export PSO_SCRIPTS="$PWD/scripts"

# Skrip tiruan yang memakai lock lalu "bekerja" beberapa detik
cat > /tmp/pso-backup-tiruan.sh <<'EOS'
#!/usr/bin/env bash
NAMA="backup-tiruan"
source "$PSO_SCRIPTS/lock.sh"
ambil_lock
sleep "${1:-5}"
log INFO "selesai"
EOS
chmod +x /tmp/pso-backup-tiruan.sh

echo "[A5-P1] lock bebas, proses jalan normal (harapan: 0)"
jalan /tmp/pso-backup-tiruan.sh 1

echo "[A5-N1] proses kedua saat lock aktif (harapan: 6)"
/tmp/pso-backup-tiruan.sh 5 >/dev/null 2>&1 &
sleep 1
jalan /tmp/pso-backup-tiruan.sh 1
wait

echo "[A5-P2] lock lepas setelah proses pertama selesai (harapan: 0)"
jalan /tmp/pso-backup-tiruan.sh 1

echo "[A5-P3] laporan BERHASIL dicatat (harapan: 0)"
jalan ./scripts/laporan.sh BERHASIL 0 "$HOME/pso-data/backup/tidak-ada.tar.gz" "uji"

echo "[A5-N2] laporan dengan status ngawur (harapan: 2)"
jalan ./scripts/laporan.sh MUNGKIN 0

echo "[A5-N3] laporan ke lokasi tidak bisa ditulis (harapan: 3)"
LAPORAN_FILE=/proc/tidak-bisa/laporan.txt jalan ./scripts/laporan.sh GAGAL 3

echo "[A5-P4/N4] Docker: baca OK, tulis read-only ditolak (harapan: 0)"
jalan ./scripts/docker_laporan.sh

echo "--- isi laporan.txt ---"
cat output/laporan.txt
rm -f /tmp/pso-backup-tiruan.sh /tmp/pso-uji.lock

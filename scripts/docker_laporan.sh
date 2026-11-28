#!/usr/bin/env bash
# docker_laporan.sh - Container membaca laporan lewat bind mount READ-ONLY (Anggota 5)
# Membuktikan: baca berhasil, tulis ditolak.
# Exit : 0 = baca OK dan tulis ditolak, 1 = docker/izin bermasalah atau bukti gagal,
#        3 = laporan.txt belum ada

NAMA="docker_laporan.sh"
DIR_SKRIP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-$DIR_SKRIP/../output/backup.log}"
OUT_DIR="$(cd "$DIR_SKRIP/.." && pwd)/output"
IMAGE="${IMAGE:-alpine:3.20}"

log() {
  local level="$1"; shift
  local baris
  baris="$(date '+%Y-%m-%d %H:%M:%S') [$level] [$NAMA] $*"
  if [ "$level" = "ERROR" ]; then echo "$baris" >&2; else echo "$baris"; fi
  mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
  echo "$baris" >> "$LOG_FILE" 2>/dev/null
}

command -v docker >/dev/null 2>&1 || { log ERROR "docker belum terpasang (exit 1)"; exit 1; }
[ -f "$OUT_DIR/laporan.txt" ] || { log ERROR "laporan.txt belum ada, jalankan laporan.sh dulu (exit 3)"; exit 3; }

DOCKER="docker"
docker info >/dev/null 2>&1 || DOCKER="sudo docker"

log INFO "[BACA] container membaca laporan via mount read-only"
if ! $DOCKER run --rm -v "$OUT_DIR:/laporan:ro" "$IMAGE" cat /laporan/laporan.txt; then
  log ERROR "container gagal membaca laporan (exit 1)"; exit 1
fi

SEBELUM="$(sha256sum "$OUT_DIR/laporan.txt" | cut -d' ' -f1)"
log INFO "[TULIS] container mencoba menulis ke mount read-only (harus ditolak)"
HASIL="$($DOCKER run --rm -v "$OUT_DIR:/laporan:ro" "$IMAGE" \
  sh -c 'echo "disusupi" >> /laporan/laporan.txt' 2>&1)"
KODE=$?
SESUDAH="$(sha256sum "$OUT_DIR/laporan.txt" | cut -d' ' -f1)"

echo "pesan container: $HASIL"
if [ "$KODE" -ne 0 ] && [ "$SEBELUM" = "$SESUDAH" ]; then
  log INFO "penulisan DITOLAK (exit container=$KODE), isi laporan.txt tidak berubah"
  exit 0
fi
log ERROR "penulisan TIDAK ditolak atau laporan berubah (exit 1)"
exit 1

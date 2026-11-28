#!/usr/bin/env bash
# laporan.sh - Catat hasil satu kali backup ke output/laporan.txt (Anggota 5)
# Pemakaian : laporan.sh <BERHASIL|GAGAL> <exit_status> [path_arsip] [keterangan...]
# Exit      : 0 = tercatat, 2 = parameter tidak valid, 3 = laporan tidak dapat ditulis

NAMA="laporan.sh"
DIR_SKRIP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-$DIR_SKRIP/../output/backup.log}"
LAPORAN_FILE="${LAPORAN_FILE:-$DIR_SKRIP/../output/laporan.txt}"

log() {
  local level="$1"; shift
  local baris
  baris="$(date '+%Y-%m-%d %H:%M:%S') [$level] [$NAMA] $*"
  if [ "$level" = "ERROR" ]; then echo "$baris" >&2; else echo "$baris"; fi
  mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
  echo "$baris" >> "$LOG_FILE" 2>/dev/null
}

if [ "$#" -lt 2 ]; then
  echo "Pemakaian: $0 <BERHASIL|GAGAL> <exit_status> [path_arsip] [keterangan...]" >&2
  log ERROR "jumlah parameter kurang (exit 2)"; exit 2
fi

STATUS="$1"; KODE="$2"; ARSIP="${3:-}"
shift 2; [ "$#" -gt 0 ] && shift
KET="$*"

case "$STATUS" in
  BERHASIL|GAGAL) ;;
  *) log ERROR "status harus BERHASIL atau GAGAL, bukan '$STATUS' (exit 2)"; exit 2 ;;
esac
case "$KODE" in
  0|2|3|4|5|6) ;;
  *) log ERROR "exit status '$KODE' tidak ada di kontrak (exit 2)"; exit 2 ;;
esac

NAMA_ARSIP="-"; UKURAN="-"
if [ -n "$ARSIP" ] && [ -f "$ARSIP" ]; then
  NAMA_ARSIP="$(basename "$ARSIP")"
  UKURAN="$(stat -c %s "$ARSIP") B"
elif [ -n "$ARSIP" ]; then
  NAMA_ARSIP="$(basename "$ARSIP") (tidak ditemukan)"
fi

mkdir -p "$(dirname "$LAPORAN_FILE")" 2>/dev/null
if [ ! -s "$LAPORAN_FILE" ]; then
  { echo "# Laporan Backup SIAKAD Dummy: waktu | status | exit | arsip | ukuran | keterangan" \
    >> "$LAPORAN_FILE"; } 2>/dev/null || { log ERROR "laporan tidak dapat ditulis: $LAPORAN_FILE (exit 3)"; exit 3; }
fi

BARIS="$(date '+%Y-%m-%d %H:%M:%S') | $STATUS | exit=$KODE | $NAMA_ARSIP | $UKURAN | ${KET:--}"
if ! { echo "$BARIS" >> "$LAPORAN_FILE"; } 2>/dev/null; then
  log ERROR "laporan tidak dapat ditulis: $LAPORAN_FILE (exit 3)"; exit 3
fi
log INFO "laporan dicatat: $STATUS exit=$KODE arsip=$NAMA_ARSIP"
exit 0

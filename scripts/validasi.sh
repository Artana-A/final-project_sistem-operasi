#!/usr/bin/env bash
# validasi.sh - Validasi sumber dan tujuan backup (Anggota 1)
# Pemakaian : validasi.sh <sumber> <tujuan>
# Exit      : 0 = valid, 2 = sumber/parameter tidak valid

NAMA="validasi.sh"
DIR_SKRIP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-$DIR_SKRIP/../output/backup.log}"

# Catat pesan ke layar dan ke log 
log() {
  local level="$1"; shift
  local baris
  baris="$(date '+%Y-%m-%d %H:%M:%S') [$level] [$NAMA] $*"
  if [ "$level" = "ERROR" ]; then echo "$baris" >&2; else echo "$baris"; fi
  mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
  echo "$baris" >> "$LOG_FILE" 2>/dev/null
}

gagal() {
  log ERROR "$1 (exit 2)"
  exit 2
}

# Cek satu direktori: ada, berupa direktori, bisa diakses
cek_direktori() {
  local label="$1" path="$2"
  [ -e "$path" ] || gagal "$label tidak ditemukan: $path"
  [ -d "$path" ] || gagal "$label bukan direktori: $path"
  if [ ! -r "$path" ] || [ ! -x "$path" ]; then
    gagal "$label tidak bisa diakses (permission): $path"
  fi
}

# 1. Validasi jumlah parameter
if [ "$#" -ne 2 ]; then
  echo "Pemakaian: $0 <sumber> <tujuan>" >&2
  gagal "jumlah parameter salah: diterima $#, seharusnya 2"
fi

SUMBER="$1"
TUJUAN="$2"

# 2. Validasi sumber
[ -n "$SUMBER" ] || gagal "parameter sumber kosong"
cek_direktori "sumber" "$SUMBER"
if [ -z "$(ls -A "$SUMBER")" ]; then
  gagal "sumber kosong, tidak ada yang bisa di-backup: $SUMBER"
fi

# 3. Validasi tujuan (ada dan berupa direktori; bisa-tidaknya ditulis dicek backup.sh)
[ -n "$TUJUAN" ] || gagal "parameter tujuan kosong"
[ -e "$TUJUAN" ] || gagal "tujuan tidak ditemukan: $TUJUAN"
[ -d "$TUJUAN" ] || gagal "tujuan bukan direktori: $TUJUAN"

log INFO "validasi OK: sumber=$SUMBER tujuan=$TUJUAN"
exit 0

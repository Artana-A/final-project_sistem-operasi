#!/usr/bin/env bash
# lock.sh - Mekanisme lock agar backup tidak jalan bersamaan (Anggota 5)
# Dipakai dengan di-source oleh skrip backup:
#     source "$DIR_SKRIP/lock.sh"
#     ambil_lock          # exit 6 kalau proses lain masih jalan
# Lock memakai flock, jadi otomatis lepas saat proses selesai/crash (tidak ada lock basi).

LOCK_FILE="${LOCK_FILE:-/tmp/pso-backup.lock}"

# Pakai log() milik skrip pemanggil; kalau belum ada, buat versi sendiri
if ! declare -F log >/dev/null; then
  NAMA="${NAMA:-lock.sh}"
  _DIR_LOCK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  LOG_FILE="${LOG_FILE:-$_DIR_LOCK/../output/backup.log}"
  log() {
    local level="$1"; shift
    local baris
    baris="$(date '+%Y-%m-%d %H:%M:%S') [$level] [$NAMA] $*"
    if [ "$level" = "ERROR" ]; then echo "$baris" >&2; else echo "$baris"; fi
    mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
    echo "$baris" >> "$LOG_FILE" 2>/dev/null
  }
fi

ambil_lock() {
  command -v flock >/dev/null 2>&1 || { log ERROR "perintah flock tidak tersedia (exit 1)"; exit 1; }
  exec 200>"$LOCK_FILE" || { log ERROR "tidak bisa membuat file lock: $LOCK_FILE (exit 3)"; exit 3; }
  if ! flock -n 200; then
    log ERROR "lock aktif, proses backup lain sedang berjalan (exit 6)"
    exit 6
  fi
  log INFO "lock diperoleh: $LOCK_FILE"
}

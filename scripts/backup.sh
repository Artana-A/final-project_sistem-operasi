#!/usr/bin/env bash
#backup.sh - membuat arsip tar.gz bernama timestamp (Anggota 2)
#Pemakaian : backup.sh [sumber] [tujuan]
#Exit      : 0 = berhasil, 2 = parameter/sumber salah, 3 = tujuan tidak dapat ditulis

NAMA="backup.sh"
DIR_SKRIP="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${LOG_FILE:-$DIR_SKRIP/../output/backup.log}"

#Default direktori sesuai kontrak
SUMBER="${1:-$HOME/pso-data/sumber}"
TUJUAN="${2:-$HOME/pso-data/backup}"

log() {
 local level="$1"; shift
 local baris
 baris="$(date '+%Y-%m-%d %H:%M:%$') [$level] [$NAMA] $*"
 echo "$baris" >&2
 mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null
 echo "$baris" >> "$LOG_FILE" 2>/dev/null
}

# 1. Validasi parameter maks 2
if [ "$#" -gt 2 ]; then
 log ERROR "jumlah parameter salah: diterima $#, maksimal 2 (exit 2)"
 exit 2
fi

# 2. cek folder sumber exist or not
if [ ! -d "$SUMBER" ] || [ ! -r "$SUMBER" ]; then
 log ERROR "sumber tidak ditemukan atau tidak bisa diakses: $SUMBER (exit 2)"
 exit 2
fi


# 3. Cek hak write tujuan (acuan dri kontrak: exit 3 jika gabisa ditulis/write)
umask 077
if [ ! -d "$TUJUAN" ] || ! touch "$TUJUAN/.uji_tulis" 2>/dev/null; then
 log ERROR "tujuan tidak dapat ditulis: $TUJUAN (exit 3)"
 exit 3
fi
rm -f "$TUJUAN/.uji_tulis"

# 4. Proses pembuatan arsip
NAMA_ARSIP="backup_siakad_$(date +%Y%m%d_%H%M%S).tar.gz"
FILE_ARSIP="$TUJUAN/$NAMA_ARSIP"

if tar -czf "$FILE_ARSIP" -C "$SUMBER" siakad_dummy nginx_dummy db 2>/dev/null; then
 UKURAN="$(du -h "$FILE_ARSIP" | cut -f1)"
 log INFO "Arsip berhasil dibuat: $FILE_ARSIP ($UKURAN)"
 echo "$FILE_ARSIP"
 exit 0
else
 rm -f "$FILE_ARSIP"
 log ERROR "tar gagal menulis arsip ke $FILE_ARSIP (exit 3)"
 exit 3
fi



#!/usr/bin/env bash
# restore.sh - Pemulihan data dari arsip backup (Anggota 4 - Tracy)
# Pemakaian: restore.sh <file_arsip.tar.gz> [folder tujuan]
#            folder_tujuan default: ~/pso-data/restore_test
# Exit: 0 = berhasil, 2 = arsip/parameter tidak valid,
#	3 = tujuan tidak dapat ditulis,
#	5 = arsip rusak/berubah, restore ditolak

NAMA="restore.sh"
DIR_SKRIP="$(cd "$(dirname "$BASH_SOURCE[0]")" && pwd)"
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

# Gagal <kode_exit> <pesan>
gagal() {
local kode="$1"; shift
log ERROR "$* (exit $kode)"
exit "$kode"
}

#----1.Validasi Parameter
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
	echo "Pemakaian: $0 <file_arsip.tar.gz> [folder_tujuan]" >&2
	gagal 2 "Jumlah parameter salah: diterima $#, seharusnya 1 atau 2"
fi

ARSIP="$1"
TUJUAN="${2:-$HOME/pso-data/restore_test}"

[ -n "$ARSIP" ] || gagal 2 "parameter arsip kosong"
[ -e "$ARSIP" ] || gagal 2 "arsip tidak ditemukan: $ARSIP"
[ -f "$ARSIP" ] || gagal 2 "arsip bukan file: $ARSIP"

#----2. Verifikasi arsip SEBELUM Restore
DIR_ARSIP="$(cd "$(dirname "$ARSIP")" && pwd)"
NAMA_ARSIP="$(basename "$ARSIP")"

[ -f "$DIR_ARSIP/$NAMA_ARSIP.sha256" ] \
  || gagal 5 "File checksum tidak ditemukan, restore ditolak: $NAMA_ARSIP.sha256"

if ! (cd "$DIR_ARSIP" && sha256sum -c "$NAMA_ARSIP.sha256" > /dev/null 2>&1); then
	gagal 5 "Checksum tidak cocok, arsip rusak/berubah, restore ditolak: $NAMA_ARSIP"
fi

if ! tar -tzf "$ARSIP" >/dev/null 2>&1; then
	gagal 5 "Isi arsip tidak bisa dibaca, restore ditolak: $NAMA_ARSIP"
fi

#-----3. Cek folder tujuan
mkdir -p "$TUJUAN" 2>/dev/null
if [ ! -d "$TUJUAN" ] || [ ! -w "$TUJUAN" ]; then
	gagal 3 "Tujuan tidak dapat ditulis: $TUJUAN"
fi 

#-----4. Restore
if tar -xzf "$ARSIP" -C "$TUJUAN"; then
  log INFO "Restore OK: arsip=$NAMA_ARSIP tujuan=$TUJUAN"
  exit 0
else
  gagal 5 "Proses ekstrak gagal: $NAMA_ARSIP"
fi

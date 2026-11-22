#!/user/bin/env bash
#backup.sh - membuat arsip tar.gz bernama waktu (Anggota 2)

DIR="$(dirname "${BASH_SOURCE[0]}")"
source "$DIR/common.sh"

buat_arsip() {
local nama tujuan
nama="backup_siakad_$(date +%Y%m%d_%H%M%S).tar.gz"
tujuan="$BACKUP_DIR/$nama"

umask 077
if ! touch "$BACKUP_DIR/.uji_tulis" 2>/dev/null; then
log ERROR "Tujuan tidak dapat ditulis: $BACKUP_DIR"
return "$EXIT_DEST"
fi
rm -f "$BACKUP_DIR/.uji_tulis"

sleep "${SIMULASI_DELAY:-0} #hanya alat uji lock/beban; default 0

if tar -czf "$tujuan" -C "$SRC_ROOT" siakad_dummy nginx
_dummy db; then
log INFO "Arsip dibuat: $tujuan ($(du -h "$tujuan" | cut -f1))"
echo "$tujuan"
else
rm -f "$tujuan"
log ERROR "tar gagal menulis arsip"
return "$EXIT_DEST"
fi
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
buat_arsip
exit $?
fi

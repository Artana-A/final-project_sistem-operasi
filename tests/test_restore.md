# Skenario Uji Restore (Anggota 4)

Penanggung jawab: Tracy Gabriella Donda Sitorus / 2510512122
Skrip: `scripts/restore.sh`
Bukti: `evidence/anggota4_restore.txt`

## Prasyarat umum
- Data dummy dibuat dengan `scripts/setup_data_dummy.sh`
- Arsip dan checksum ada di `~/pso-data/backup/` (`backup_siakad_YYYYMMDD_HHMMSS.tar.gz` dan `.tar.gz.sha256`)
- Folder `~/pso-data/restore_test/` dikosongkan sebelum tiap uji

## Kasus uji
TBA

## Prosedur pemulihan kondisi uji
- `rm -rf ~/pso-data/backup_rusak`
- `chmod 755 ~/tujuan_ro && rmdir ~/tujuan_ro`
- `rm -rf ~/pso-data/restore_test/*`

## Catatan
Pada uji negatif, penolakan dengan exit status bukan nol adalah hasil yang benar.

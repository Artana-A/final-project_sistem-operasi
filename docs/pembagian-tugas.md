# Pembagian Tugas dan Skenario (Topik 5A - Sistem Otomasi Backup dan Pemulihan Data Linux)

## Daftar Tanggung Jawab

Anggota:
1. Aisyah Putriarta Lenggu (2510512049) - Validasi sumber dan parameter
2. Arya Ramadhan Kawi (2510512073) - Pembuatan arsip 
3. Muhammad Raehansya (2510512127) - Verifikasi integritas
4. Shabrina Hikmah Shafiyyah (2510512114) - Lock, log, laporan, dan Docker
5. Tracy Gabriella Donda Sitorus (2510512122) - Pemulihan data

## Kontrak Bersama

**1. Lokasi folder dan nama arsip**
- Data dummy: `~/pso-data/` berisi `/sumber` (siakad-dummy, nginx_dummy, db), `backup/`, dan `restore_test/`
- Laporan dan log: `output/laporan.txt` dan `output/backup.log` (di dalam folder repository, tidak masuk Git)
- Nama arsip: `backup_siakad_YYYYMMDD_HHMMSS.tar.gz`, dengan checksum-nya di file `.sha256` dengan nama sama


**2. Exit status**

Kode = Arti

0 = Berhasil
2 = Sumber atau parameter tidak valid
3 = Tujuan tidak dapat ditulis
4 = Checksum tidak cocok
5 = Arsip rusak, restore ditolak
6 = Lock aktif, proses lain sedang berjalan

**3. Format log**

`YYYY-MM-DD HH:MM:SS [INFO/WARN/ERROR] [nama_script] pesan`







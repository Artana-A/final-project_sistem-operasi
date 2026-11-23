# Sistem Operasi Backup dan Pemulihan Data Linux

Proyek Akhir Sistem Operasi dan Praktikum Sistem Operasi, S1 Sistem Informasi, UPN Veteran Jakarta.
Topik: 5A - Otomasi Backup dan Pemulihan Data
Kasus: Pemulihan Web Sistem Informasi Akademik (SIAKAD)

## Anggota
1. Aisyah Putriarta Lenggu (2510512049)
2. Arya Ramadhan Kawi (2510512073)
3. Muhammad Raehansya (2510512127)
4. Shabrina Hikmah Shafiyyah (2510512114)
5. Tracy Grabriella Donda Sitorus (2510512122)

Detail skenario dan kontribusi: lihat [docs/pembagian-tugas.md](docs/pembagian-tugas.md)

## Lingkungan
- OS: Ubuntu 26.04 LTS (Desktop)
- vCPU: 1
- RAM: -/+ 1.6 GiB
- Docker: Docker version 29.1.3 (image: alpine:3.20)

## Instalasi
1. Clone repositori ini dan masuk ke direktori proyek:
   ```bash
   git clone <url-repositori-kalian>
   cd <nama-folder-repositori>
   ```
2. Beri izin eksekusi pada seluruh skrip:
   ```bash
   chmod +x scripts/*.sh tests/*.sh
   ```
3. Siapkan direktori dan data dummy di `~/pso-data/`:
   ```bash
   ./scripts/setup_data_dummy.sh
   ```
   
## Menjalankan
### 1. Validasi Sumber dan Parameter (Anggota 1 - Aisyah)
```bash
./scripts/validasi.sh ~/pso-data/sumber ~/pso-data/backup
```
### 2. Pembuatan Arsip (Anggota 2 - Arya)

### 3. Verifikasi Integritas (Anggota 3 - Raehansya)

### 4. Lock, Log, dan Laporan (Anggota 5 - Shabrina)
- **Mencatat hasil eksekusi ke laporan (`output/laporan.txt`):**
  ```bash
  ./scripts/laporan.sh <BERHASIL|GAGAL> <exit_status> [path_arsip] [keterangan]
  ```
- *(Modul `scripts/lock.sh` di-source otomatis oleh skrip backup untuk mencegah proses berjalan bersamaan).*

### 5. Pemulihan Data (Anggota 4 - Tracy)
Jalankan skrip pemulihan dengan menyertakan path file arsip backup (`.tar.gz`)[cite: 1]:
```bash
./scripts/restore.sh ~/pso-data/backup/backup_siakad_YYYYMMDD_HHMMSS.tar.gz
```
*(Contoh: `./scripts/restore.sh ~/pso-data/backup/backup_siakad_20261123_103307.tar.gz`)*

## Menguji
Jalankan skrip pengujian otomatis masing-masing modul:
- **Uji validasi (Anggota 1 - Aisyah):**
  ```bash
  ./tests/anggota1_validasi.sh
  ```
- **Uji pembuatan arsip (Anggota 2 - Arya):**
- **Uji verifikasi integritas (Anggota 3 - Raehansya):**
  
- **Uji pemulihan data (Anggota 4 - Tracy):**
 
- **Uji lock, log, laporan, dan Docker (Anggota 5 - Shabrina):**
  ```bash
  ./tests/anggota5_lock_log_docker.sh
  ```

## Aktivitas Docker
Container menggunakan image `alpine:3.20` dengan *bind mount* mode **read-only (`:ro`)** ke direktori `output/` untuk memastikan container dapat membaca file laporan namun ditolak saat mencoba mengubah isinya:
```bash
./scripts/docker_laporan.sh
```
*(Pastikan `output/laporan.txt` sudah terbentuk sebelum menjalankan skrip ini)

## Pemulihan dan Pembersihan Kondisi Uji
Setiap skrip pengujian di folder `tests/` otomatis membersihkan file sementara setelah selesai berjalan[cite: 1]. Untuk mereset ulang seluruh data dummy, hasil backup, file lock, dan log dari awal:
```bash
rm -rf ~/pso-data output/* /tmp/pso-*.lock
./scripts/setup_data_dummy.sh
```



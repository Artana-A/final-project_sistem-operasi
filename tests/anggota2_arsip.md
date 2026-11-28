# Dokumentasi Uji: Anggota 2 (Pembuatan Arsip)

## 1. Skenario Uji Fungsi

### T-A2_P1: Skenario Positif (Pembuatan Arsip Berhasil)
- **Langkah:** Menjalankan './scripts/backup.sh'
- **Harapan:** Status keluar '0' dan file '.tar.gz' dibuat
- **Hasil:** [BELUM DIUJI]

### T-A2-P2: Skenario Positif (Integritas Arsip)
- **Langkah** Mengekstrak arsip ke '/tmp' dan membandingkan dengan folder sumber menggunakan 'diff -r'
- **Harapan** Status keluar '3' (gagal menulis)
- **Hasil** [BELUM DIUJI]

## 2. Pengamatan Performa CPU & Memori ('time -v)

| Parameter | Beban kecil (Normal) | Beban Besar (+200MB) |
| :--- | :--- | :--- |
| CPU % | [BELUM DIUJI] | [BELUM DIUJI] |
| Max RAM (KB) | [BELUM DIUJI] | [BELUM DIUJI] |
| Waktu (Elapsed) | [BELUM DIUJI] | [BELUM DIUJI] |

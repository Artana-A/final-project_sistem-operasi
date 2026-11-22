# DOkumentasi Uji: A2 (Pembuatan Arsip)

#1. SKenario Uji
- **T-A2-P1 (Positif):** Backup normal & cek daftar isi (exit 0).
- **T-A2-P2 (Positif):** Ekstrak dan bandingkan dengan diff -r (hasil sama).
- **T-A2-N1 (Negatif):** Folder tujuan read-only (exit 3).

#2. Tabel Pengamatan CPU & Memori ('time -v)
| Parameter | Beban Kecil (Normal) | Beban Besar (+200MB) |
| :--- | :--- | :--- |
| CPU % | ... | ... |
Max RAM (KB) | ... | ... |
Waktu (Elapsed) | ... | ... |

*Catatan: Bukti terminal tersimpan di folder evidence/a2_...*

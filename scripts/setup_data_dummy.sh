#!/usr/bin/env bash

#Membuat data dummy untuk uji backup (dapat dijalankan berulang kali)

DATA_ROOT="$HOME/pso-data"

mkdir -p "$DATA_ROOT/sumber/siakad_dummy" "$DATA_ROOT/sumber/nginx_dummy" \
	"$DATA_ROOT/sumber/db" "$DATA_ROOT/backup" "$DATA_ROOT/restore_test"

echo "<h1>SIAKAD Dummy</h1>" > "$DATA_ROOT/sumber/siakad_dummy/index.html"
echo "server { listen 80; server_name dummy.local; }" > "$DATA_ROOT/sumber/nginx_dummy/nginx.conf"
echo "CREATE TABLE mahasiswa (id INT, nama VARCHAR(50));" > "$DATA_ROOT/sumber/db/dump_database.sql"

chmod 700 "$DATA_ROOT/backup"
echo "Data dummy siap di $DATA_ROOT"


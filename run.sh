#!/bin/bash
set -e

echo "[+] Installing tools..."
sudo apt update
sudo apt install -y lz4 simg2img e2fsprogs unzip tar megatools

echo "[+] Downloading fold6ap.zip from MEGA..."
megadl "https://mega.nz/file/j5ACRbQL#1v6gDbftqpVlsXi6dLo_4DoxFSmiEH28mYDhOPBD-5Y"

echo "[+] Extracting AP tar.md5..."
unzip fold6ap.zip "AP_F956B*.tar.md5"
tar -xvf AP_F956B*.tar.md5 system.img.lz4

echo "[+] Decompressing system.img.lz4..."
lz4 -d system.img.lz4 system.img
simg2img system.img system.raw.img

echo "[+] Extracting APKs..."
debugfs -w system.raw.img <<EOF
cd /system/priv-app/SmartSuggestions
dump SmartSuggestions.apk SmartSuggestions.apk
cd /system/priv-app/AODService
dump AODService.apk AODService.apk
quit
EOF

echo "[✓] APKs extracted: SmartSuggestions.apk, AODService.apk"

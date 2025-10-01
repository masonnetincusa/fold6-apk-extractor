#!/bin/bash

# Exit on error
set -e

# Step 1: Install required tools
echo "[+] Installing tools..."
sudo apt update
sudo apt install -y lz4 simg2img e2fsprogs unzip tar megatools

# Step 2: Download from MEGA
echo "[+] Downloading fold6ap.zip from MEGA..."
megadl "PASTE_YOUR_MEGA_LINK_HERE"

# Step 3: Extract AP tar.md5
echo "[+] Extracting AP tar.md5..."
unzip fold6ap.zip "AP_F956B*.tar.md5"

# Step 4: Extract system.img.lz4
echo "[+] Extracting system.img.lz4..."
tar -xvf AP_F956B*.tar.md5 system.img.lz4

# Step 5: Decompress and convert
echo "[+] Decompressing system.img.lz4..."
lz4 -d system.img.lz4 system.img
echo "[+] Converting to raw ext4..."
simg2img system.img system.raw.img

# Step 6: Dump APKs
echo "[+] Extracting APKs with debugfs..."
debugfs -w system.raw.img <<EOF
cd /system/priv-app/SmartSuggestions
dump SmartSuggestions.apk SmartSuggestions.apk
cd /system/priv-app/AODService
dump AODService.apk AODService.apk
quit
EOF

echo "[✓] Extraction complete. APKs saved in:"
echo "    - SmartSuggestions.apk"
echo "    - AODService.apk"

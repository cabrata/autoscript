#!/bin/bash
# Restore AutoScript Xray backup created by backup.sh
# Usage: restore.sh /path/to/backup.tar.gz  OR restore.sh <gdrive|http> URL
set -euo pipefail

backup_file="${1:-}"
if [ -z "$backup_file" ]; then
  read -e -p "Masukkan path file backup (.tar.gz) atau link GDrive/HTTP: " backup_file
fi

tmp_download=""
if [ -f "$backup_file" ]; then
  : # local file ok
elif [[ "$backup_file" =~ ^https?:// ]]; then
  tmp_download=$(mktemp /tmp/backup-restore-XXXX.tar.gz)
  if command -v gdown >/dev/null 2>&1; then
    gdown --fuzzy "$backup_file" -O "$tmp_download"
  else
    if command -v pip3 >/dev/null 2>&1; then
      pip3 install --no-cache-dir gdown >/dev/null 2>&1
      gdown --fuzzy "$backup_file" -O "$tmp_download"
    else
      echo "gdown tidak tersedia dan pip3 tidak ditemukan. Unduh manual lalu jalankan restore lagi."
      exit 1
    fi
  fi
  backup_file="$tmp_download"
else
  echo "File/link tidak ditemukan: $backup_file"
  exit 1
fi

echo "Menghentikan layanan terkait..."
for svc in xray vmess-grpc vless-grpc udp-custom client-sldns server-sldns ws-dropbear ws-stunnel; do
  systemctl stop "$svc" 2>/dev/null || true
done

echo "Menjalankan restore ke root (/)..."
tar -xzf "$backup_file" -C /

if [ -f /etc/iptables.up.rules ]; then
  echo "Memulihkan aturan iptables..."
  iptables-restore < /etc/iptables.up.rules 2>/dev/null || true
  netfilter-persistent save 2>/dev/null || true
  netfilter-persistent reload 2>/dev/null || true
fi

echo "Memuat ulang daemon & menyalakan layanan..."
systemctl daemon-reload
for svc in nginx sshd xray vmess-grpc vless-grpc udp-custom client-sldns server-sldns ws-dropbear ws-stunnel openvpn stunnel4; do
  systemctl restart "$svc" 2>/dev/null || true
done

echo "Restore selesai. Periksa kembali domain/sertifikat dan pastikan layanan aktif."

[ -n "$tmp_download" ] && rm -f "$tmp_download"

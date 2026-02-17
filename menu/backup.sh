#!/bin/bash
# Backup AutoScript Xray configs, users, and services
# Usage: backup.sh [output_dir]
# If rclone remote "gdrive:" is configured, upload automatically and print share link.
set -uo pipefail

OUT_DIR=${1:-/root}
timestamp=$(date +%F-%H%M%S)
outfile="$OUT_DIR/backup-autoscript-$timestamp.tar.gz"
REMOTE=${BACKUP_REMOTE:-gdrive:autoscript-backup}

add_if_exists() {
  [ -e "$1" ] && include+=( "$1" )
}

include=()
mkdir -p "$OUT_DIR"

echo "Menyiapkan daftar file untuk dibackup..."
# Core configs
add_if_exists "/etc/xray"
add_if_exists "/etc/v2ray"
add_if_exists "/etc/ssh/sshd_config"
add_if_exists "/etc/ssh/sshd_config.d"
add_if_exists "/etc/openvpn"
add_if_exists "/etc/slowdns"
add_if_exists "/etc/ipsec.d"
add_if_exists "/etc/ppp"
add_if_exists "/etc/iptables.up.rules"
add_if_exists "/home/vps/public_html"
add_if_exists "/home/re_otm"
add_if_exists "/etc/cron.d/xp_otm"
add_if_exists "/root/udp"
add_if_exists "/root/nsdomain"
# System accounts (needed agar user SSH ikut tersalin)
add_if_exists "/etc/passwd"
add_if_exists "/etc/shadow"
add_if_exists "/etc/group"
add_if_exists "/etc/gshadow"
# Logs create user (agar daftar akun mudah dilihat setelah restore)
add_if_exists "/etc/log-create-ssh.log"
add_if_exists "/etc/log-create-vless.log"
add_if_exists "/etc/log-create-vmess.log"
add_if_exists "/etc/log-create-trojan.log"

# Domain & certificates (acme)
if [ -f /etc/xray/domain ]; then
  domain=$(cat /etc/xray/domain)
  add_if_exists "/root/.acme.sh/${domain}_ecc"
  add_if_exists "/etc/xray/domain"
  add_if_exists "/etc/xray/scdomain"
  add_if_exists "/root/domain"
fi

# Systemd units for custom services
add_if_exists "/etc/systemd/system/udp-custom.service"
add_if_exists "/etc/systemd/system/vmess-grpc.service"
add_if_exists "/etc/systemd/system/vless-grpc.service"
add_if_exists "/etc/systemd/system/xolpanel.service"
add_if_exists "/etc/systemd/system/client-sldns.service"
add_if_exists "/etc/systemd/system/server-sldns.service"
add_if_exists "/etc/systemd/system/ws-dropbear.service"
add_if_exists "/etc/systemd/system/ws-stunnel.service"

# Menu binaries (only if present)
for f in /usr/bin/menu /usr/bin/m-* /usr/bin/xray-renew /usr/bin/addgrpc /usr/bin/delgrpc /usr/bin/renewgrpc /usr/bin/cekgrpc; do
  [ -e "$f" ] && include+=( "$f" )
done

if [ "${#include[@]}" -eq 0 ]; then
  echo "Tidak ada file/dir yang ditemukan untuk dibackup."
  exit 1
fi

echo "Membuat arsip $outfile ..."
tar -czf "$outfile" "${include[@]}"
echo "Backup selesai dibuat di: $outfile"

# Upload to Google Drive via rclone if configured
if command -v rclone >/dev/null 2>&1; then
  remote_name=${REMOTE%%:*}:
  if rclone listremotes 2>/dev/null | grep -q "^${remote_name}$"; then
    target_path=$REMOTE
    rclone mkdir "$target_path" >/dev/null 2>&1 || true
    if rclone copy "$outfile" "$target_path" --quiet; then
      echo "Upload selesai ke $target_path"
    else
      echo "Upload ke $target_path gagal; arsip tetap ada di lokal: $outfile"
      exit 0
    fi
    fname=$(basename "$outfile")
    link=$(rclone link "$target_path/$fname" 2>/dev/null || true)
    [ -n "$link" ] && echo "Share link: $link"
  else
    echo "rclone terpasang tapi remote $remote_name tidak ditemukan. Simpan file lokal di $outfile"
  fi
else
  echo "rclone tidak terpasang; file backup tersedia lokal: $outfile"
fi

exit 0

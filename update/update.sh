#!/bin/bash

echo "┌─────────────────────────────────────────────────┐"
echo "│            UPDATE SCRIPT BY CALIPHDEV           │"
echo "└─────────────────────────────────────────────────┘"
echo ""
echo "Update Script..."

# Define base URL
BASE_URL="https://raw.githubusercontent.com/ngacaprak0809-commits/skytunel/refs/heads/master"

# Function to download and install a file
update_file() {
    local file_path=$1
    local file_url=$2
    local tmp_file="/tmp/$(basename "$file_path")"

    echo "Downloading $(basename "$file_path")..."
    if wget -q -O "$tmp_file" "$file_url"; then
        mv "$tmp_file" "$file_path"
        chmod +x "$file_path"
        echo "[OK] Updated $file_path"
    else
        echo "[FAIL] Failed to download $file_path"
    fi
}

# Update files
update_file "/usr/bin/menu" "$BASE_URL/menu/menu.sh"
update_file "/usr/bin/m-sshovpn" "$BASE_URL/menu/m-sshovpn.sh"
update_file "/usr/bin/m-vmess" "$BASE_URL/menu/m-vmess.sh"
update_file "/usr/bin/m-vless" "$BASE_URL/menu/m-vless.sh"
update_file "/usr/bin/m-trojan" "$BASE_URL/menu/m-trojan.sh"
update_file "/usr/bin/m-system" "$BASE_URL/menu/m-system.sh"
update_file "/usr/bin/m-ssws" "$BASE_URL/menu/m-ssws.sh"
update_file "/usr/bin/m-webmin" "$BASE_URL/menu/m-webmin.sh"
update_file "/usr/bin/running" "$BASE_URL/menu/running.sh"
update_file "/usr/bin/bw" "$BASE_URL/menu/bw.sh"
update_file "/usr/bin/m-tcp" "$BASE_URL/menu/tcp.sh"
update_file "/usr/bin/auto-reboot" "$BASE_URL/menu/auto-reboot.sh"
update_file "/usr/bin/clearcache" "$BASE_URL/menu/clearcache.sh"
update_file "/usr/bin/restart" "$BASE_URL/menu/restart.sh"
update_file "/usr/bin/m-domain" "$BASE_URL/menu/m-domain.sh"
update_file "/usr/bin/m-dns" "$BASE_URL/menu/m-dns.sh"
update_file "/usr/bin/m-l2tp" "$BASE_URL/menu/m-l2tp.sh"
update_file "/usr/bin/m-pptp" "$BASE_URL/menu/m-pptp.sh"
update_file "/usr/bin/m-sstp" "$BASE_URL/menu/m-sstp.sh"
update_file "/usr/bin/m-update" "$BASE_URL/update/update.sh"

# Update version file
echo "Updating Version..."
serverV=$(curl -sS "$BASE_URL/menu/versi")
if [ -n "$serverV" ]; then
    echo "$serverV" > /opt/.ver
    echo "[OK] Version updated to $serverV"
else
    echo "[FAIL] Failed to fetch version"
fi

echo ""
echo "Update Done..."
sleep 2
menu

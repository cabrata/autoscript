#!/bin/bash

echo -e "\\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\\033[0m"
echo -e "\\E[0;100;33m          • SYSTEM MENU •          \\E[0m"
echo -e "\\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\\033[0m"
echo -e ""
echo -e " [\\e[36m•1\\e[0m] Panel Domain"
echo -e " [\\e[36m•2\\e[0m] Speedtest VPS"
echo -e " [\\e[36m•3\\e[0m] Set Auto Reboot"
echo -e " [\\e[36m•4\\e[0m] Restart All Service"
echo -e " [\\e[36m•5\\e[0m] Cek Bandwith"
echo -e " [\\e[36m•6\\e[0m] Install TCP BBR"
echo -e " [\\e[36m•7\\e[0m] DNS CHANGER"
echo -e " [\\e[36m•8\\e[0m] Update Script"
echo -e " [\\e[36m•9\\e[0m] Backup Config"
echo -e " [\\e[36m•10\\e[0m] Restore Config"
echo -e ""
echo -e " [\\e[31m•0\\e[0m] \\e[31mBACK TO MENU\\033[0m"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e   ""
echo -e "\\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\\033[0m"
echo -e ""
script_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
backup_cmd="$script_dir/backup.sh"
restore_cmd="$script_dir/restore.sh"
[ -x /usr/bin/backup.sh ] && backup_cmd="/usr/bin/backup.sh"
[ -x /usr/bin/restore.sh ] && restore_cmd="/usr/bin/restore.sh"

read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; m-domain ; exit ;;
2) clear ; speedtest ; exit ;;
3) clear ; auto-reboot ; exit ;;
4) clear ; restart ; exit ;;
5) clear ; bw ; exit ;;
6) clear ; m-tcp ; exit ;;
7) clear ; m-dns ; exit ;;
8) clear ; m-update ; exit ;;
9) clear ; bash "$backup_cmd" ; read -n1 -s -r -p "Tekan sembarang tombol untuk kembali..."; exit ;;
10) clear ; bash "$restore_cmd" ; exit ;;
0) clear ; menu ; exit ;;
x) exit ;;
*) echo -e "" ; echo "Anda salah tekan" ; sleep 1 ; m-system ;;
esac

#!/bin/bash
MYIP=$(curl -sS ifconfig.me)
echo "Checking VPS"
clear
# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
BCyan='\e[1;36m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
# VPS Information
#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# user
Exp2=$"Lifetime"
Name=$"caliphvpn"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
#ISP=$(curl -s ipinfo.io/org?token=ce3da57536810d | cut -d " " -f 2-10 )
#CITY=$(curl -s ipinfo.io/city?token=ce3da57536810d )
#WKT=$(curl -s ipinfo.io/timezone?token=ce3da57536810d )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
DATE2=$(date -R | cut -d " " -f -5)
IPVPS=$(curl -s ifconfig.me )
LOC=$(curl -s ifconfig.co/country )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
clear 
# Garis Pembatas Box
garis="${CYAN}┌─────────────────────────────────────────────────┐${NC}"
tengah="${CYAN}│${NC}"
bawah="${CYAN}└─────────────────────────────────────────────────┘${NC}"
pembatas="${CYAN}├─────────────────────────────────────────────────┤${NC}"

clear
echo -e "${RED}┌─────────────────────────────────────────────────┐${NC}"
echo -e "${RED}│                AJI SYSTEM PREMIUM               │${NC}"
echo -e "${RED}└─────────────────────────────────────────────────┘${NC}"
echo -e "$garis"
echo -e "$tengah ${YELLOW}OS      ${NC}: $(hostnamectl | grep "Operating System" | cut -d ' ' -f5-) "
echo -e "$tengah ${YELLOW}UPTIME  ${NC}: $uptime "
echo -e "$tengah ${YELLOW}IP      ${NC}: $IPVPS "
echo -e "$tengah ${YELLOW}CITY    ${NC}: $LOC "
echo -e "$tengah ${YELLOW}DOMAIN  ${NC}: $domain "
echo -e "$tengah ${YELLOW}DATE    ${NC}: $DATE2 "
echo -e "$pembatas"
echo -e "$tengah ${BLUE}RAM USED   ${NC}: $uram MB / $tram MB "
echo -e "$tengah ${BLUE}CPU USAGE  ${NC}: $cpu_usage "
echo -e "$pembatas"
echo -e "$tengah ${GREEN}DOWNLOAD   ${NC}: $dtoday "
echo -e "$tengah ${GREEN}UPLOAD     ${NC}: $utoday "
echo -e "$tengah ${GREEN}TOTAL      ${NC}: $ttoday "
echo -e "$pembatas"
echo -e "$tengah ${CYAN} XRAY : ON ${NC}|${CYAN} SSH-WS : ON ${NC}|${CYAN} STATUS : GOOD ${NC} $tengah"
echo -e "$pembatas"
echo -e "$tengah ${YELLOW} 1.)${NC} Menu SSH          ${YELLOW} 8.)${NC} Menu SSTP      "
echo -e "$tengah ${YELLOW} 2.)${NC} Menu Vmess        ${YELLOW} 9.)${NC} Menu Setting   "
echo -e "$tengah ${YELLOW} 3.)${NC} Menu Vless        ${YELLOW}10.)${NC} Status Service "
echo -e "$tengah ${YELLOW} 4.)${NC} Menu Trojan       ${YELLOW}11.)${NC} Clear RAM      "
echo -e "$tengah ${YELLOW} 5.)${NC} Menu Shadowsocks  ${YELLOW}12.)${NC} Reboot VPS     "
echo -e "$tengah ${YELLOW} 6.)${NC} Menu L2TP         ${YELLOW}13.)${NC} Update Script  "
echo -e "$tengah ${YELLOW} 7.)${NC} Menu PPTP         ${YELLOW} r.)${NC} Xray Renew     "
echo -e "$tengah ${YELLOW} x.)${NC} Exit Script                       "
echo -e "$pembatas"
echo -e "$tengah ${GREEN} Client Name ${NC}: $Name "
echo -e "$tengah ${GREEN} Expired     ${NC}: $Exp2 "
echo -e "$bawah"
echo -e " ${CYAN}---------- t.me/caliphdev / @AjiStore ----------${NC}"
echo ""
read -p " Select menu :  "  opt
echo -e   ""
case $opt in
1) clear ; m-sshovpn ;;
2) clear ; m-vmess ;;
3) clear ; m-vless ;;
4) clear ; m-trojan ;;
5) clear ; m-ssws ;;
6) clear ; m-l2tp ;;
7) clear ; m-pptp ;;
8) clear ; m-sstp ;;
9) clear ; m-system ;;
10) clear ; running ;;
11) clear ; clearcache ;;
12) clear ; reboot ; /sbin/reboot ;;
13) clear ; m-update ;;
r) clear ; xray-renew ;;
x) exit ;;
*) echo "Silahkan masukkan pilihan dengan benar! " ; sleep 1 ; menu ;;
esac


#!/bin/bash

EXPIRED_FILE="/etc/xray/expired.txt"
mkdir -p /etc/xray
touch "$EXPIRED_FILE"

now=$(date +"%Y-%m-%d")

############################
# AUTO REMOVE VMESS (###)
############################
grep -E '^### ' /etc/xray/config.json | while read -r marker user exp; do
    # marker = "###", user = nama, exp = yyyy-mm-dd
    [ -z "$user" ] && continue
    [ -z "$exp" ] && continue

    d1=$(date -d "$exp" +%s 2>/dev/null) || continue
    d2=$(date -d "$now" +%s)
    exp2=$(( (d1 - d2) / 86400 ))

    if [ "$exp2" -le 0 ]; then
        # Ambil block client VMESS untuk marker ini
        block=$(sed -n "/^### $user $exp/,/^},{/p" /etc/xray/config.json)

        # Ambil UUID (field "id")
        uuid=$(echo "$block" | grep -m1 '"id"' | cut -d'"' -f4)

        # Simpan ke expired.txt
        if [ -n "$uuid" ]; then
            echo "$now vmess $user $uuid $exp" >> "$EXPIRED_FILE"
        fi

        # Hapus user dari config.json
        sed -i "/^### $user $exp/,/^},{/d" /etc/xray/config.json
    fi
done

############################
# AUTO REMOVE VLESS (#&)
############################
grep -E '^#& ' /etc/xray/config.json | while read -r marker user exp; do
    [ -z "$user" ] && continue
    [ -z "$exp" ] && continue

    d1=$(date -d "$exp" +%s 2>/dev/null) || continue
    d2=$(date -d "$now" +%s)
    exp2=$(( (d1 - d2) / 86400 ))

    if [ "$exp2" -le 0 ]; then
        block=$(sed -n "/^#& $user $exp/,/^},{/p" /etc/xray/config.json)
        uuid=$(echo "$block" | grep -m1 '"id"' | cut -d'"' -f4)

        if [ -n "$uuid" ]; then
            echo "$now vless $user $uuid $exp" >> "$EXPIRED_FILE"
        fi

        sed -i "/^#& $user $exp/,/^},{/d" /etc/xray/config.json
    fi
done

############################
# AUTO REMOVE TROJAN (#!)
############################
grep -E '^#! ' /etc/xray/config.json | while read -r marker user exp; do
    [ -z "$user" ] && continue
    [ -z "$exp" ] && continue

    d1=$(date -d "$exp" +%s 2>/dev/null) || continue
    d2=$(date -d "$now" +%s)
    exp2=$(( (d1 - d2) / 86400 ))

    if [ "$exp2" -le 0 ]; then
        block=$(sed -n "/^#! $user $exp/,/^},{/p" /etc/xray/config.json)

        # Trojan pakai "password"
        uuid=$(echo "$block" | grep -m1 '"password"' | cut -d'"' -f4)

        if [ -n "$uuid" ]; then
            echo "$now trojan $user $uuid $exp" >> "$EXPIRED_FILE"
        fi

        sed -i "/^#! $user $exp/,/^},{/d" /etc/xray/config.json
    fi
done

systemctl restart xray

##------ Auto Remove SSH (TIDAK DIUBAH)
hariini=`date +%d-%m-%Y`
cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
totalaccounts=`cat /tmp/expirelist.txt | wc -l`
for((i=1; i<=$totalaccounts; i++ ))
do
    tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
    username=`echo $tuserval | cut -f1 -d:`
    userexp=`echo $tuserval | cut -f2 -d:`
    userexpireinseconds=$(( $userexp * 86400 ))
    tglexp=`date -d @$userexpireinseconds`
    tgl=`echo $tglexp |awk -F" " '{print $3}'`
    while [ ${#tgl} -lt 2 ]
    do
        tgl="0"$tgl
    done
    while [ ${#username} -lt 15 ]
    do
        username=$username" "
    done
    bulantahun=`echo $tglexp |awk -F" " '{print $2,$6}'`
    todaystime=`date +%s`
    if [ $userexpireinseconds -ge $todaystime ] ;
    then
        :
    else
        userdel --force $username
    fi
done

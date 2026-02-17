#!/bin/bash

MAX=1
if [ -e "/var/log/auth.log" ]; then
    OS=1
    LOG="/var/log/auth.log"
elif [ -e "/var/log/secure" ]; then
    OS=2
    LOG="/var/log/secure"
fi

# Restart SSH service sesuai OS
if [ $OS -eq 1 ]; then
    service ssh restart > /dev/null 2>&1
else
    service sshd restart > /dev/null 2>&1
fi

# Jika ada argumen, jadikan MAX
[[ ${1+x} ]] && MAX=$1

# Ambil daftar user di /home
cat /etc/passwd | grep "/home/" | cut -d":" -f1 > /root/user.txt
username_list=( $(cat /root/user.txt) )
jumlah=()
pid=()

for ((i=0; i<${#username_list[@]}; i++)); do
    jumlah[$i]=0
    pid[$i]=""
done

# Ambil log login SSH
grep -i sshd $LOG | grep -i "Accepted password for" > /tmp/log-ssh.txt

# Ambil pid ssh sesi aktif
proc=( $(ps aux | grep "\[priv\]" | awk '{print $2}') )

for PID in "${proc[@]}"; do
    grep "sshd\[$PID\]" /tmp/log-ssh.txt > /tmp/log-ssh-pid.txt
    NUM=$(wc -l < /tmp/log-ssh-pid.txt)
    USER=$(awk '{print $9}' /tmp/log-ssh-pid.txt)
    IP=$(awk '{print $11}' /tmp/log-ssh-pid.txt)

    if [ "$NUM" -eq 1 ]; then
        for ((i=0; i<${#username_list[@]}; i++)); do
            if [ "$USER" == "${username_list[$i]}" ]; then
                jumlah[$i]=$((jumlah[$i] + 1))
                pid[$i]="${pid[$i]} $PID"
            fi
        done
    fi
done

# Eksekusi kill jika lebih dari MAX
hit=0
for ((i=0; i<${#username_list[@]}; i++)); do
    if [ ${jumlah[$i]} -gt $MAX ]; then
        date=$(date +"%Y-%m-%d %X")
        echo "$date - ${username_list[$i]} - ${jumlah[$i]}"
        echo "$date - ${username_list[$i]} - ${jumlah[$i]}" >> /root/log-limit.txt
        kill ${pid[$i]}
        hit=$((hit + 1))
    fi
done

# Restart ssh jika ada yang dikill
if [ $hit -gt 0 ]; then
    if [ $OS -eq 1 ]; then
        service ssh restart > /dev/null 2>&1
    else
        service sshd restart > /dev/null 2>&1
    fi
fi

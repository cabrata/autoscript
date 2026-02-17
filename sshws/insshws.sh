#!/bin/bash
clear
cd

#Install Script Websocket-SSH golang
wget -O /usr/local/bin/ws-stunnel.go https://raw.githubusercontent.com/ngacaprak0809-commits/skytunel/refs/heads/master/sshws/ws-stunnel.go
/usr/local/go/bin/go build -o /usr/local/bin/ws-stunnel /usr/local/bin/ws-stunnel.go
chmod +x /usr/local/bin/ws-stunnel
wget -O /etc/systemd/system/ws-stunnel.service https://raw.githubusercontent.com/ngacaprak0809-commits/skytunel/refs/heads/master/sshws/ws-stunnel.service && chmod +x /etc/systemd/system/ws-stunnel.service


#restart service
systemctl daemon-reload

#Enable & Start & Restart ws-openssh service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service

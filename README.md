# AutoScript X-Ray

> Direct installation script for X-Ray & SSH tunneling — **no VPS IP registration required**.

---

## 📌 Before You Start (MUST READ)

- VPS **must be fresh** / never had another script installed.
- If you install this script **twice**, you **MUST** rebuild your VPS to factory settings.
- Use your own domain (recommended), or a random domain / bug host.
- Recommended OS: **Ubuntu 18 / 20 LTS** (most stable).

---

## 🖥️ Supported Linux Distributions

<h2 align="center">Supported Linux Distribution</h2>

<p align="center">
  <img src="https://d33wubrfki0l68.cloudfront.net/5911c43be3b1da526ed609e9c55783d9d0f6b066/9858b/assets/img/debian-ubuntu-hover.png">
</p>

<p align="center">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2011&message=Bullseye&color=purple">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2012&message=Bookworm&color=purple">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2020&message=LTS&color=red">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2022&message=LTS&color=red">
</p>

---

## 🧾 Minimum VPS Requirements

- OS:
  - **Debian 11 / 12**
  - **Ubuntu 20 / 22 LTS**
- CPU: **Minimum 1 core**
- RAM: **Minimum 1 GB**
- Stable VPS network connection
- Recommended OS:
  - **Ubuntu 20 / 22 LTS**

---

## 🛡️ Included Services

<p align="center">
  <img src="https://img.shields.io/badge/Service-SSH_Over_Websocket-success.svg">
  <img src="https://img.shields.io/badge/Service-SSH_UDP_Custom-success.svg">
  <img src="https://img.shields.io/badge/Service-Stunnel4-success.svg">
  <img src="https://img.shields.io/badge/Service-Fail2Ban-brightgreen">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Service-XRAY_VLESS-success.svg">
  <img src="https://img.shields.io/badge/Service-XRAY_VMESS-success.svg">
  <img src="https://img.shields.io/badge/Service-XRAY_TROJAN-success.svg">
  <img src="https://img.shields.io/badge/Service-Websocket-success.svg">
  <img src="https://img.shields.io/badge/Service-GRPC-success.svg">
  <img src="https://img.shields.io/badge/Service-Shadowsocks-success.svg">
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Service-Webmin-success.svg">
  <img src="https://img.shields.io/badge/Service-Helium-success.svg">
</p>

<p align="center">
  <img src="https://wangchujiang.com/sb/status/stable.svg">
</p>

---

## 🌐 Recommended Cloudflare Settings

For users with a personal domain, refer to  
**/image** folder for example configurations:  
https://github.com/givpn/AutoScriptXray/tree/master/image

### Cloudflare Configuration:

- `SSL/TLS` : **FULL**
- `SSL/TLS Recommender` : **OFF**
- `gRPC` : **ON**
- `WebSocket` : **ON**
- `Always Use HTTPS` : **OFF**
- `Under Attack Mode` : **OFF**

---

## 🎯 DNS Pointing

Make sure your DNS pointing is correct before installing the script.

![Pointing](https://autoscript.caliphdev.com/image/pointing.png)

---

## 🔌 Services & Ports

```text
OpenSSH                  : 22
SSH Websocket            : 80
SSH SSL Websocket        : 443
Stunnel4                 : 222, 777
Badvpn                   : 7100-7900
Nginx                    : 81

Vmess WS TLS             : 443
Vless WS TLS             : 443
Trojan WS TLS            : 443
Shadowsocks WS TLS       : 443

Vmess WS None TLS        : 80
Vless WS None TLS        : 80
Trojan WS None TLS       : 80
Shadowsocks WS None TLS  : 80

Vmess gRPC               : 443
Vless gRPC               : 443
Trojan gRPC              : 443
Shadowsocks gRPC         : 443
````

---

## ⚙️ Features

* Speedtest® by [Ookla®](https://speedtest.net)
* Auto-reboot scheduler
* Restart all services
* Auto-remove **expired users**
* Bandwidth checker
* BBRPlus v1.4.0 by [Chikage0o0](https://github.com/Chikage0o0)
  Wondering what BBR is? → [Google Search](https://www.google.com/search?q=what+bbr+in+linux)
* DNS Changer
* No auto-backup (feature permanently removed)
* You may add extra custom features manually

### 🔧 Optional Features (Install After Main Setup)

* Optional: [OpenVPN + SlowDNS + UDP-Custom](https://github.com/givpn/AutoScriptXray/tree/master/udp-custom)

  * UDP-Custom by [Exe302](https://gitlab.com/Exe302)
  * SlowDNS by [SL](https://github.com/fisabiliyusri)

* Optional: [Webmin Panel + Ads Block (Helium v3.0)](https://github.com/givpn/AutoScriptXray/tree/master/helium)
  by [Abi Darwish](https://github.com/abidarwish)

* Optional: [Xolpanel Telegram Bot](https://github.com/givpn/AutoScriptXray/tree/master/bot%20telegram%20panel)
  by [XolvaID](https://github.com/XolvaID)

---

## 🧰 Menu Preview

### Main Menu

![Menu](https://autoscript.caliphdev.com/image/menu.png)

### Service Status

![Service Status](https://autoscript.caliphdev.com/image/service.png)

---

## 🚀 Installation Guide

### Step 1 — (Debian Only) Update & Reboot

```bash
apt update && apt upgrade -y && reboot
```

After reboot, proceed to Step 2.

### Step 2 — (Ubuntu & Debian) Run Installer

```bash
sysctl -w net.ipv6.conf.all.disable_ipv6=1 \
 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 \
 && apt update \
 && apt install -y bzip2 gzip coreutils screen curl unzip \
 && wget https://autoscript.caliphdev.com/setup.sh \
 && chmod +x setup.sh \
 && sed -i -e 's/\r$//' setup.sh \
 && screen -S setup ./setup.sh
```

> **Note:** Run as root. If any error occurs, screenshot your terminal for troubleshooting.

---

## 💰 Support / Donate

Support the development of this project:

[![PayPal donate button](https://img.shields.io/badge/Donate-PayPal-yellow)](https://paypal.me/caliphdev)
[![QRIS donate button](https://img.shields.io/badge/Donate-QRIS-red)](https://autoscript.caliphdev.com/image/qris.jpg)

---

## ⚠️ Disclaimer (READ CAREFULLY)

* **Selling this script is strictly prohibited.**
  This script was obtained for free from the internet.
* Your internet usage records & logs are **not my responsibility** as the script provider.
* All network logs are controlled by:

  * Your VPS provider
  * Potentially, law enforcement agencies (e.g., **FBI**)
* Use responsibly to avoid issues.
* Watching adult content is **your own responsibility**.

---

## 📝 Final Message

* Thank you for taking the time to read this documentation.
* I apologize if there are mistakes or inappropriate words.
* I am also human — mistakes are normal.

---

## 📜 License & Credits

<p align="center">
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" style="max-width:200%;">
  </a>
</p>

<p align="center">
  <a href="//github.com/caliph91/autoscript">
    <img src="https://img.shields.io/badge/caliphvpn-autoscript%202024-blue" style="max-width:200%;">
  </a>
</p>

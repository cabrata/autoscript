# AutoScript X-Ray

> Direct install script for X-Ray & SSH tunneling — **no VPS IP registration needed**.

---

## 📌 Before You Start (MUST READ)

- VPS **harus masih fresh** / belum pernah diinstall script lain.
- Jika kamu install script ini **dua kali**, **WAJIB** rebuild VPS ke factory default dari panel provider.
- Gunakan domain sendiri (disarankan), boleh juga random subdomain / bug host.
- Rekomendasi OS: **Debian 11 / 12 LTS** (paling stabil).

---

## 🖥️ Supported Linux Distributions

<h2 align="center">Supported Linux Distribution</h2>

<p align="center">
  <img src="https://d33wubrfki0l68.cloudfront.net/5911c43be3b1da526ed609e9c55783d9d0f6b066/9858b/assets/img/debian-ubuntu-hover.png">
</p>

<p align="center">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%211&message=Bullseye&color=purple">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=debian&label=Debian%2012&message=Bookworm&color=purple">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2020&message=Lts&color=red">
  <img src="https://img.shields.io/static/v1?style=for-the-badge&logo=ubuntu&label=Ubuntu%2022&message=Lts&color=red">
</p>

---

## 🧾 Minimum VPS Requirements

- OS:
  - **Debian 11 / 12**
  - **Ubuntu 20 / 22 LTS**
- CPU: **Minimal 1 core**
- RAM: **Minimal 1 GB**
- Koneksi internet VPS stabil
- Recommendation:
  - **Debian 11 / 12 LTS** (paling stable untuk script ini)

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

## 🌐 Cloudflare Settings (Recommended)

Untuk yang menggunakan domain sendiri, contoh pengaturan bisa dilihat di folder  
[**image/**](https://github.com/givpn/AutoScriptXray/tree/master/image).

**Recommended Cloudflare config:**

- `SSL/TLS` : **FULL**
- `SSL/TLS Recommender` : **OFF**
- `GRPC` : **ON**
- `WEBSOCKET` : **ON**
- `Always Use HTTPS` : **OFF**
- `UNDER ATTACK MODE` : **OFF**

---

## 🎯 DNS Pointing

Pastikan pointing DNS sudah benar sebelum install script.

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

Vmess WS none TLS        : 80
Vless WS none TLS        : 80
Trojan WS none TLS       : 80
Shadowsocks WS none TLS  : 80

Vmess gRPC               : 443
Vless gRPC               : 443
Trojan gRPC              : 443
Shadowsocks gRPC         : 443
````

---

## ⚙️ Features

* Speedtest® by [Ookla®](https://speedtest.net)
* Set Auto Reboot
* Restart all services
* Auto delete **expired users**
* Bandwidth checker
* BBRPLUS v1.4.0 by [Chikage0o0](https://github.com/Chikage0o0) —
  penasaran apa itu BBR? [Search BBR di Google](https://www.google.com/search?q=what+bbr+in+linux)
* DNS Changer
* Tidak ada auto-backup (fitur ini **permanen dihapus**)
* Fitur lain bisa kamu tambahkan manual sesuai kebutuhan

### 🔧 Optional / Extra Features

Install **setelah Step Install utama selesai**:

* Optional: [OpenVPN + SlowDNS + UDP-Custom](https://github.com/givpn/AutoScriptXray/tree/master/udp-custom)

  * UDP-Custom by [Exe302](https://gitlab.com/Exe302)
  * SlowDNS by [SL](https://github.com/fisabiliyusri)
* Optional: [Panel Webmin + ADS Block (Helium v3.0)](https://github.com/givpn/AutoScriptXray/tree/master/helium)
  by [Abi Darwish](https://github.com/abidarwish)
* Optional: [Bot Telegram Xolpanel](https://github.com/givpn/AutoScriptXray/tree/master/bot%20telegram%20panel)
  by [XolvaID](https://github.com/XolvaID)

---

## 🧰 Menu Preview

### Main Menu

![Menu](https://autoscript.caliphdev.com/image/menu.png)

### Service Status

![Service Status](https://autoscript.caliphdev.com/image/service.png)

---

## 🚀 Installation Guide

### Step 1 — (Debian only) Update & Reboot

```bash
apt update && apt upgrade -y && reboot
```

Setelah VPS menyala lagi, lanjut ke Step 2.

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

> **Note:** Jalankan sebagai root. Jika terjadi error, cek log di terminal atau screenshot untuk dianalisa.

---

## 💰 Donate / Support

Bantu dukung pengembangan script ini:

[![PayPal donate button](https://img.shields.io/badge/Donate-PayPal-yellow)](https://paypal.me/caliphdev)
[![QRIS donate button](https://img.shields.io/badge/Donate-QRIS-red)](https://autoscript.caliphdev.com/image/qris.jpg)

---

## ⚠️ Disclaimer (MUST READ)

* **Dilarang menjual script ini.** Script ini didapat gratis dari internet.
* Keamanan data & riwayat penggunaan internet **bukan tanggung jawab** penyedia script.
* Semua data dan aktivitas internet kamu dikelola oleh:

  * Provider jaringan / VPS
  * (Mungkin) pihak berwenang seperti **FBI** dan lain-lain 😄
* Gunakan secara bijak untuk menghindari masalah.
* Menonton konten dewasa adalah **tanggung jawab masing-masing**.

---

## 📝 Final Message

* Terima kasih sudah meluangkan waktu untuk membaca.
* Maaf jika ada kata-kata yang kurang berkenan.
* Saya juga manusia yang tidak luput dari kesalahan.

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

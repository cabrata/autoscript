# install udp-custom + slowdns + OpenVPN

- (NOTE) Slowdns limit speed
- Upload : 3 Mbps
- Download : 3 Mbps

```
apt update && apt install wget -y && wget -qO- -O udp.sh "https://raw.githubusercontent.com/ngacaprak0809-commits/skytunel/refs/heads/master/udp-custom/udp.sh" && chmod +x udp.sh && ./udp.sh
```

- NS Pointing
  ![Service Status](https://autoscript.caliphdev.com/udp-custom/slowdns/nspointing.png)

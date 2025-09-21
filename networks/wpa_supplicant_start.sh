/etc/wpa_supplicant/wpa_supplicant.conf:
```
country=CN
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="WIFI hotspot SSID"
    psk="your-password"
}
```

sudo wpa_supplicant -B -i wlp3s0 -c /etc/wpa_supplicant/wpa_supplicant.conf

#sudo dhclient wlp3s0

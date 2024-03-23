# Refer: https://www.baeldung.com/linux/connect-to-hidden-wireless-network

# Add
nmcli con add type wifi con-name <connect name> ifname <ifname> ssid <ssid>
nmcli con modify <connect name> wifi-sec.key-mgmt wpa-psk
nmcli con modify <connect name> wifi-sec.psk <password>
nmcli con up <connect name>

# Delete
nmcli con delete <connect name>


# Another method (NOT to verified)
nmcli dev wifi connect <ssid> password <password> hidden yes

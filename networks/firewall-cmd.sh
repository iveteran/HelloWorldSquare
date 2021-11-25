# open a service
sudo firewall-cmd --zone=public --add-service=https --permanent

# open a port
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent

# enable changes
sudo firewall-cmd --reload

# list
sudo firewall-cmd --list-all

# list services
#firewall-cmd --get-services
# show service info
#firewall-cmd --info-service ssh

# zones
#firewall-cmd --list-all-zones
#firewall-cmd --info-zone=zone_name
#firewall-cmd --zone=zone --change-interface=interface_name
#firewall-cmd --get-default-zone
#firewall-cmd --set-default-zone=zone

# To add a service to a zone:
#firewall-cmd --zone=zone_name --add-service service_name
# Removing service:
#firewall-cmd --zone=zone_name --remove-service service_name

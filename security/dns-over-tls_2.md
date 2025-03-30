## Enable DNS Over TLS in Linux using Systemd

[Source](https://medium.com/@jawadalkassim/enable-dns-over-tls-in-linux-using-systemd-b03e44448c1c)
Refer: [Wiki of Arch Linux](https://wiki.archlinux.org/title/Systemd-resolved)

For those who didn’t know what DNS over TLS means

DNS over TLS (DoT) is a security protocol for encrypting and wrapping Domain Name System (DNS) queries and answers via the Transport Layer Security (TLS) protocol. The goal of the method is to increase user privacy and security by preventing eavesdropping and manipulation of DNS data via man-in-the-middle attacks. qouted from DNS-OVER-TLS wikipedia page.

Internet is not a happy place if you’re not Well protected, not all browsers support DNS over TLS or DNS over HTTPS, and none of them use it by default

Systemd has a perfect service called systemd-resolved , allows you to tunnel all DNS requests from your system with DNS over TLS, that means extra protection and there’s no need for your browser to bring this feature because you’re already full protected,

Systemd-resolved enabled by default in Ubuntu and Ubuntu based Distros

Step 1 (Optinal) : check service status in your system :
```
$ resolvectl status
```

Step 2 : Set-up systemd-resolved
```
$ cat /etc/systemd/resolved.conf
```

should give you this output:
```
[Resolve]
#DNS=
#FallbackDNS=
#Domains=
#LLMNR=no
#MulticastDNS=no
#DNSSEC=no
#DNSOverTLS=no
#Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes
```

Now we have to modify this file:
```
$ sudo nano /etc/systemd/resolved.conf
```

apply these changes and save the file
```
[Resolve]
DNS=1.1.1.1 1.0.0.1
FallbackDNS=8.8.8.8 8.8.4.4
Domains=~.
#LLMNR=no
#MulticastDNS=no
DNSSEC=yes
DNSOverTLS=yes
#Cache=yes
#DNSStubListener=yes
#ReadEtcHosts=yes
```
Make sure remove ‘#’ Before the modified options.

A quick note about the options:

DNS: A space-separated list of IPv4 and IPv6 addresses to use as system DNS servers
FallbackDNS: A space-separated list of IPv4 and IPv6 addresses to use as the fallback DNS servers.
Domains: These domains are used as search suffixes when resolving single-label host names, ~. stand for use the system DNS server defined with DNS= preferably for all domains.
DNSOverTLS: If true all connections to the server will be encrypted. Note that this mode requires a DNS server that supports DNS-over-TLS and has a valid certificate for it’s IP.
DNSSEC: allows a user, application, or recursive resolver to trust that the answer to their DNS query is what the domain owner intends it to be.

Step 3 : Restart Services or Log out
```
$ sudo systemctl restart NetworkManager
$ sudo systemctl restart systemd-resolved
```

Step 4 : Check if everything is fine
```
$ systemctl status systemd-resolved
$ resolvectl status
```

the Output should be:
```
Global
       LLMNR setting: no
MulticastDNS setting: no
  DNSOverTLS setting: yes
      DNSSEC setting: yes
    DNSSEC supported: yes
  Current DNS Server: 1.1.1.1
         DNS Servers: 1.1.1.1
                      1.0.0.1
Fallback DNS Servers: 8.8.8.8
                      8.8.4.4
          DNS Domain: ~.
```

Also test your connection here :
https://1.1.1.1/help

Step 5 : Verify
```
$ resolvectl query archlinux.org
```

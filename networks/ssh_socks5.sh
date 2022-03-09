#!/bin/sh

ssh -f -N -D 0.0.0.0:4433 localhost

# -f Run background
# -N Do not execute a remote command. this is useful for just for‐warding ports
# -D Dynamic forward
# 0.0.0.0:4433, Listen address
# localhost, SSH server, localhost means using local machine SSH server

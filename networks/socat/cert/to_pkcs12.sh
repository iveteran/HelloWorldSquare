#!/bin/sh

#openssl pkcs12 -export -out cert.p12 -in cert.pem -inkey key.pem
#openssl pkcs12 -export -out cert.p12 -in cert.pem -inkey key.pem -passout pass: -nokeys
#openssl pkcs12 -export -out cert.p12 -in cert.pem -inkey key.pem -passout pass: 123

openssl pkcs12 -export -out client.p12 -in client.crt -inkey client.key

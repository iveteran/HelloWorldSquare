#!/bin/sh

# make a simple http server by python, the document root is current directory
python3 -m http.server 8080 -d .

#!/bin/bash

[[ -f /config/keys/cert.key &&  -f /config/keys/cert.crt ]] && (echo "using keys found in /config/keys" && exit 0)

SUBJECT="//C=US/ST=CA/L=Carlsbad/O=Linuxserver.io/OU=LSIO Server/CN=*"
echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
openssl req -new -x509 -days 3650 -nodes -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "$SUBJECT"

chown abc:abc -R /config/keys



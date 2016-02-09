#!/bin/bash
set -e
[[ -f /config/keys/cert.key && -f /config/keys/cert.crt ]] && (echo "using keys found in /config/keys" && chown abc:abc -R /config/keys && exit 0)

echo "generating self-signed keys in /config/keys, you can replace these with your own keys if required"
openssl req -new -x509 -days 3650 -nodes -out /config/keys/cert.crt -keyout /config/keys/cert.key -subj "//C=US/ST=CA/L=Carlsbad/O=Linuxserver.io/OU=LSIO Server/CN=*"
chown abc:abc -R /config/keys




#!/bin/bash

[[ ! -f /config/www/owncloud/config/config.php ]] && exit 0

if [ "$(grep -c "memcache.local" "/config/www/owncloud/config/config.php")" == "0" ]; then
echo "blah"
# sed -i -e "'memcache.local' => '\OC\Memcache\APCu'," /config/www/owncloud/config/config.php
fi




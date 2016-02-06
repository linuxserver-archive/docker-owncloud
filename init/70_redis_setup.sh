#!/bin/bash

[[ ! -f /config/www/owncloud/config/config.php ]] && exit 0

if [ "$(grep -c "redis" "/config/www/owncloud/config/config.php")" == "0" ]; then
sed -i -e "/'installed' => true,/r /defaults/owncloud_redis.conf" /config/www/owncloud/config/config.php
fi


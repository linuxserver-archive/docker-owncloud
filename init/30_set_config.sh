#!/bin/bash

mkdir -p config/{nginx/site-confs,www,log/mysql,log/nginx,keys,redis_data} /var/{log/redis,run/php}

[[ ! -f /config/nginx/nginx.conf ]] && cp /defaults/nginx.conf /config/nginx/nginx.conf

[[ ! -f /config/nginx/nginx-fpm.conf ]] && cp /defaults/nginx-fpm.conf /config/nginx/nginx-fpm.conf

[[ ! -f /config/nginx/site-confs/default ]] && cp /defaults/default /config/nginx/site-confs/default

[[ ! -f /config/redis.conf ]] && cp /etc/redis/redis.conf /config/redis.conf

[[ ! -d $DATADIR ]] && mkdir -p "$DATADIR"

[[ ! -d /var/run/mysqld ]] && mkdir -p /var/run/mysql

chown abc:abc /data
chown -R abc:abc /config /var/{log/redis,run/php}
chmod -R 777 /var/run/mysqld




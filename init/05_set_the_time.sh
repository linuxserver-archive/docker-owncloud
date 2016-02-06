#!/bin/bash

if [[ $(cat /etc/timezone) != "$TZ" ]] ; then
  echo "$TZ" > /etc/timezone
  dpkg-reconfigure -f noninteractive tzdata
sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php/7.0/fpm/php.ini
sed -i -e "s#;date.timezone.*#date.timezone = ${TZ}#g" /etc/php/7.0/cli/php.ini
fi



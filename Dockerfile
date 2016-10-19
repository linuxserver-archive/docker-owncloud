FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# set owncloud initial install version and mariadb folders
ENV MYSQL_DIR="/config"
ENV DATADIR=$MYSQL_DIR/database

ENV BUILD_APTLIST="php7.0-dev" \
APTLIST="exim4 exim4-base exim4-config exim4-daemon-light git-core heirloom-mailx jq libaio1 libapr1 \
libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libdbd-mysql-perl libdbi-perl libfreetype6 \
libmysqlclient18 libpcre3-dev libsmbclient.dev nano nginx openssl php-apcu php7.0-bz2 php7.0-cli \
php7.0-common php7.0-curl php7.0-fpm php7.0-gd php7.0-gmp php7.0-imap php7.0-intl php7.0-ldap \
php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-xml php7.0-xmlrpc php7.0-zip \
php-imagick pkg-config smbclient re2c ssl-cert wget" \
DB_APTLIST="mariadb-server mysqltuner"

# add repositories
RUN \
  # mariadb
add-apt-repository 'deb http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main' && \
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db && \
 # nginx
echo "deb http://ppa.launchpad.net/nginx/development/ubuntu trusty main" >> /etc/apt/sources.list.d/nginx.list && \
echo "deb-src http://ppa.launchpad.net/nginx/development/ubuntu trusty main" >> /etc/apt/sources.list.d/nginx.list && \
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 00A6F0A3C300EE8C && \
 # php7
echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list.d/php7.list && \
echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" >> /etc/apt/sources.list.d/php7.list && \
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 4F4EA0AAE5267A6C && \
 # python
add-apt-repository ppa:fkrull/deadsnakes-python2.7 

# install packages
RUN apt-get update -q && \
apt-get install \
$DB_APTLIST $APTLIST $BUILD_APTLIST -qy && \

# build libsmbclient support
git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \
cd /tmp/smbclient && \
phpize && \
./configure && \
make && \
make install && \
echo "extension=smbclient.so" > /etc/php/7.0/mods-available/smbclient.ini && \

# install apcu 
git clone https://github.com/krakjoe/apcu /tmp/apcu && \
cd /tmp/apcu && \
phpize && \
./configure && \
make && \
make install && \
echo "extension=apcu.so" > /etc/php/7.0/mods-available/apcu.ini && \

# cleanup 
cd / && \
apt-get purge --remove $BUILD_APTLIST -y && \
apt-get autoremove -y && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql && \
mkdir -p /var/lib/mysql

# add some files 
COPY services/ /etc/service/
COPY  defaults/ /defaults/
COPY init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh && \

# configure fpm for owncloud
echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /defaults/nginx-fpm.conf

# expose ports
EXPOSE 443

# set volumes
VOLUME /config /data


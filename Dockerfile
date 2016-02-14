FROM linuxserver/baseimage

MAINTAINER Sparklyballs <sparklyballs@linuxserver.io>

# set owncloud initial install version and mariadb folders
ENV MYSQL_DIR="/config"
ENV DATADIR=$MYSQL_DIR/database

ENV BUILD_APTLIST="php7.0-dev"
ENV APTLIST="exim4 exim4-base exim4-config exim4-daemon-light git-core heirloom-mailx jq libaio1 libapr1 \
libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libdbd-mysql-perl libdbi-perl libfreetype6 \
libmysqlclient18 libpcre3-dev libsmbclient.dev mariadb-server mysql-common mysqltuner nano nginx \
openssl php7.0-bz2 php7.0-cli php7.0-curl php7.0-fpm php7.0-gd php7.0-gmp php7.0-imap php7.0-intl \
php7.0-ldap php7.0-mcrypt php7.0-mysql php7.0-opcache php-imagick php-xml-parser smbclient \
ssl-cert wget"

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
$APTLIST $BUILD_APTLIST -qy && \

# build libsmbclient support
git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \
cd /tmp/smbclient && \
phpize && \
./configure && \
make && \
make install && \
echo "extension=smbclient.so" > /etc/php/mods-available/smbclient.ini && \

# cleanup 
cd / && \
apt-get purge --remove $BUILD_APTLIST -y && \
apt-get autoremove -y && \
apt-get clean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/mysql && \
mkdir -p /var/lib/mysql

# add some files 
ADD services/ /etc/service/
ADD defaults/ /defaults/
ADD init/ /etc/my_init.d/
RUN chmod -v +x /etc/service/*/run /etc/my_init.d/*.sh && \

# configure fpm for owncloud
echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /defaults/nginx-fpm.conf && \

# configure mariadb
sed -i 's/key_buffer\b/key_buffer_size/g' /etc/mysql/my.cnf && \
sed -ri 's/^(bind-address|skip-networking)/;\1/' /etc/mysql/my.cnf && \
sed -i s#/var/log/mysql#/config/log/mysql#g /etc/mysql/my.cnf && \
sed -i -e 's/\(user.*=\).*/\1 abc/g' /etc/mysql/my.cnf && \
sed -i -e "s#\(datadir.*=\).*#\1 $DATADIR#g" /etc/mysql/my.cnf && \
sed -i "s/user='mysql'/user='abc'/g" /usr/bin/mysqld_safe && \
cp /etc/mysql/my.cnf /defaults/my.cnf

# expose ports
EXPOSE 443

# set volumes
VOLUME /config /data


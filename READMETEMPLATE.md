![http://linuxserver.io](http://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](https://www.linuxserver.io/) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](https://forum.linuxserver.io/index.php) or for real-time support our [IRC](https://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`.

# linuxserver/owncloud
OwnCloud provides universal access to your files via the web, your computer or your mobile devices — wherever you are. Mariadb 10 and redis server are built into the image. Built with php7, mariadb 10.1 and nginx 1.9.10. [Owncloud.](https://owncloud.org/)


## Usage

```
docker create --name=owncloud -v <path to config>:/config \
-v <path to data>:/data -e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> -e DB_PASS=<password> \
-p 443:443 linuxserver/owncloud
```

**Parameters**

* `-p 433` - the port(s)
* `-v /config` - path to owncloud config files and database
* `-v /data` - path for owncloud to store data
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `-e TZ` timezone information -eg Europe/London
* `-e DB_PASS` owncloud database password - see below for explanation

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it owncloud /bin/bash`.

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.

## Setting up the application
* initial webui startup, enter a username and password you want for your user in the setup screen.
* IMPORTANT, change the data folder to /data.
* IMPORTANT, because the database is built into the container, the database host is localhost and the database user and the database itself are both owncloud.
*  If you do not set the DB_PASS variable, the database password will default to owncloud.
* After initial setup has completed, you need to restart the container with, docker restart owncloud , this sets the redis configuration for you.
* IMPORTANT, if you use your own keys name them cert.key and cert.crt, and place them in config/keys folder.

## Updates

* Update owncloud through the webui
* To monitor the logs of the container in realtime `docker logs -f owncloud`.



## Versions

+ **dd.MM.yyyy:** Initial Release.


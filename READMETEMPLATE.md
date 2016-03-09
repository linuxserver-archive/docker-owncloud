![https://linuxserver.io](https://www.linuxserver.io/wp-content/uploads/2015/06/linuxserver_medium.png)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring auto-update on startup, easy user mapping and community support. Find us for support at:
* [forum.linuxserver.io](https://forum.linuxserver.io)
* [IRC](https://www.linuxserver.io/index.php/irc/) on freenode at `#linuxserver.io`
* [Podcast](https://www.linuxserver.io/index.php/category/podcast/) covers everything to do with getting the most from your Linux Server plus a focus on all things Docker and containerisation!

# linuxserver/owncloud
OwnCloud provides universal access to your files via the web, your computer or your mobile devices — wherever you are. Mariadb 10.1 is built into the image. Built with php7, mariadb 10.1 and nginx 1.9.10. [Owncloud.](https://owncloud.org/)


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


### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Setting up the application
* initial webui startup, enter a username and password you want for your user in the setup screen.
* IMPORTANT, change the data folder to /data.
* IMPORTANT, because the database is built into the container, the database host is localhost and the database user and the database itself are both owncloud.
*  If you do not set the DB_PASS variable, the database password will default to owncloud.
* IMPORTANT, if you use your own keys name them cert.key and cert.crt, and place them in config/keys folder.

## Updates

* Shell access whilst the container is running: `docker exec -it container-name /bin/bash`
* Upgrade owncloud from the webui, `Daily branch does not work, so just don't...`
* To monitor the logs of the container in realtime: `docker logs -f owncloud`



## Versions

+ **dd.MM.yyyy:** Initial Release.



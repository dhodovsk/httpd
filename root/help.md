% httpd(2)
% Rado Pitonak \<rpitonak@redhat.com\>
% DATE 07.06.2017

Name
----------------------------------
httpd - web server container based on baseruntime, using httpd module

Description
----------------------------------
Apache HTTP Server 2.4 available as docker container, is a powerful, efficient, and extensible web server. Apache supports a variety of features, many implemented as compiled modules which extend the core functionality. These can range from server-side programming language support to authentication schemes. Virtual hosting allows one Apache installation to serve many different Web sites.

Usage
----------------------------------

```
$ docker run -p 8080:8080 -p 443:443 -v <DIR>:/var/www/ modularitycontainers/httpd
```
This starts the container and forwards port 8080 from container to port 8080 on host.
Substitute <DIR> with **absolute** path to your web root. You may also need to change SELinux settings like following.

```
chcon -Rt svirt_sandbox_file_t <DIR>
```

Volumes
----------------------------------

Website root directory.

```
/var/www/
```

Configuration directory.

```
/etc/httpd/conf/
```

Examples
----------------------------------

Mount custom configuration inside the container

```
$ docker run -p 8080:8080 -v <CONF_DIR>:/etc/httpd/conf -v <DIR>:/var/www/ modularitycontainers/httpd
```

Security Implications
----------------------------------
```
-p 8080:8080
```
Opens  container  port  8080  and  maps it to the same port on the Host.

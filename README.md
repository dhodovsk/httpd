# httpd web server container
An example **httpd container** is based on fedora 25.  This container is being developed - test it, play with it, but please **don't use it in production**.

## Configuration
This repository contains file **httpd.conf** in files directory where you can configure all settings for httpd running in container.

## Running in Docker

### 1) Shell
```
$ docker run -p 80:80 -v <DIR>:/var/www/html rpitonak/httpd-container
```
This starts the container and forwards port 80 from container to port 80 on host.
Substitute <DIR> with **absolute** path to your web root. You may also need to change SELinux settings like following.
Note that it is only for **testing purpose**.
```
chcon -Rt svirt_sandbox_file_t <DIR>
```

### 2) Makefile
```
$ make
```
This will build container and tag it. You can change tag and port be editing following lines:
```
#docker tag name
IMAGE_NAME = httpd

PORT = 80
```

If you specify `DIR_PATH` variable executing make will also **run** the container.

```
#absolute path to your web root
#DIR_PATH = /
```

# httpd web server container
An example **httpd container** is based on fedora 25.  This container is being developed - test it, play with it, but please **don't use it in production**.

## Configuration
This repository contains file **httpd.conf** in files directory where you can configure all settings for httpd running in container.

## Running in Docker

### 1) Shell
```
$ docker run -p 80:80 -v <DIR>:/var/www/ rpitonak/httpd
```
This starts the container and forwards port 80 from container to port 80 on host.
Substitute <DIR> with **absolute** path to your web root. You may also need to change SELinux settings like following.

```
chcon -Rt svirt_sandbox_file_t <DIR>
```
Note that this is only for **testing purpose**. You can find more information about handling permissions in docker containers on this links:
* [Handling Permissions with Docker Volumes](https://denibertovic.com/posts/handling-permissions-with-docker-volumes/)
* [Practical SELinux and Containers](http://www.projectatomic.io/blog/2016/03/dwalsh_selinux_containers/)
* [Using Volumes with Docker can Cause Problems with SELinux](http://www.projectatomic.io/blog/2015/06/using-volumes-with-docker-can-cause-problems-with-selinux/)

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

If you specify `DIR_PATH` variable, executing make will also **run** the container.

```
#absolute path to your web root
#DIR_PATH = /
```

## Running in OpenShift
To run this container in OpenShift, you need to change the `RunAsUser` option in the `restricted` Security Context Constraint (SCC) from `MustRunAsRange` to `RunAsAny`. Do it by running:

```
$ oc login -u system:admin
$ oc project default
$ oc edit scc restricted
```

Find `RunAsUser` and change its value from `MustRunAsRange` to `RunAsAny`.

Then you will be able to run the container using the `openshift-template.yaml` template in this repo:

```
$ oc login -u developer
$ oc create -f openshift-template.yaml
```

## Httpd container for development

This container can be used also in interactive way what can be useful for development.

First you need to put [this script](./files/development/) wherever you want. (e.g **~/bin/** )

Make script executable
```
chmod +x httpd-container
```

Then add path to script to `$PATH` enviroment variable.
Note: If you want to make it work also after reboot, you need to add this line to **~/.bashrc** .
```
$ export PATH=$PATH":~/bin/"
```

Then you can use this command **in the directory** with your website, to start container with running httpd and interactive shell.
```
$ httpd-container
```

Httpd Docker image
====================

This repository contains Dockerfile for Apache HTTP server 2.4 based on [baseruntime](""https://hub.docker.com/r/baseruntime/baseruntime/) for the Fedora 26 Boltron general usage.
For more information about modules see official [Fedora Modularity documentation](docs.pagure.org/modularity/) and [httpd module](https://github.com/modularity-modules/httpd) repository.


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
Note that this is only for **testing purpose**. You can find more information about handling permissions in docker containers on this links:
* [Handling Permissions with Docker Volumes](https://denibertovic.com/posts/handling-permissions-with-docker-volumes/)
* [Practical SELinux and Containers](http://www.projectatomic.io/blog/2016/03/dwalsh_selinux_containers/)
* [Using Volumes with Docker can Cause Problems with SELinux](http://www.projectatomic.io/blog/2015/06/using-volumes-with-docker-can-cause-problems-with-selinux/)


Test
--------------------------------------
This repository also provides tests (based on [MTF](https://pagure.io/modularity-testing-framework/tree/master)) which checks basic functionality of the MariaDB image.

Run the tests using Makefile :
```
$ make test
```

Running in Openshift
--------------------------------------
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

Httpd container for development
--------------------------------------

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

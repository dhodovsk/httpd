FROM fedora:25

# Description
# Volumes:
# * /var/www - Web root directory
# Exposed ports:
# * 80 - standard protocol for http
# * 443 - secure http protocol
# * 8080 - alternate http protocol

#install httpd service without documentation and clean cache
RUN  dnf install -y --setopt=tsflags=nodocs httpd && \
     dnf -y clean all

MAINTAINER Rado Pitonak <rpitonak@redhat.com>

LABEL summary = "Httpd is a secure, efficient and extensible web server that provides HTTP services.  " \
      name = "httpd" \
      version = "2.4" \
      release = "0.1"

# add configuration file for web server
ADD files/httpd.conf /etc/httpd/conf/httpd.conf

# add run script
ADD files/run-script.sh /run-script.sh

# make run script executable
RUN chmod +x run-script.sh

# VOLUME instruction creates unnamed volume and mounts it to the provided path,
# you can override this behavior by mounting
# a selected host directory into container: "-v <host_directory>:<container_directory>"
VOLUME /var/www/

# EXPOSE instruction exposes port from container to host.
# Specify it during `docker run` as parameter: "-p <host_port>:<container_port>"
EXPOSE 80
EXPOSE 443
EXPOSE 8080

# Command which will start httpd service during command `docker run`
CMD /bin/sh /run-script.sh

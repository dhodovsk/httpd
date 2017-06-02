FROM registry.fedoraproject.org/fedora:26

# Description
# Volumes:
# * /var/www - Web root directory
# Exposed ports:
# * 80 - standard protocol for http
# * 443 - secure http protocol
# * 8080 - alternate http protocol

ENV HTTPD_VERSION=2.4.25 \
    NAME=httpd \
    VERSION=0 \
    RELEASE=0.1 \
    ARCH=x86_64

LABEL summary="Apache HTTP Server" \
      name="$FGC/$NAME" \
      version="$VERSION" \
      release="$RELEASE.$DISTTAG" \
      architecture="$ARCH" \
      com.redhat.component=$NAME \
      usage="docker run -p 80:80 -v <DIR>:/var/www/ f26/httpd" \
      description="The Apache HTTP Server is a powerful, efficient, and extensible web server." \
      vendor="Fedora Project" \
      org.fedoraproject.component="httpd" \
      authoritative-source-url="registry.fedoraproject.org" \
      io.k8s.description="The Apache HTTP Server is a powerful, efficient, and extensible web server." \
      io.k8s.display-name="httpd" \
      io.openshift.tags="httpd"

COPY help.1 /
#install httpd service without documentation and clean cache
RUN  dnf install -y --setopt=tsflags=nodocs httpd && \
     dnf -y clean all

MAINTAINER Rado Pitonak <rpitonak@redhat.com>

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

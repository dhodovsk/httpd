FROM baseruntime/baseruntime:latest
# Description
# Volumes:
# * /var/www - Web root directory
# * /etc/httpd/conf/ - Configuration files directory
# Exposed ports:
# * 80 - standard protocol for http
# * 443 - secure http protocol
# * 8080 - alternate http protocol

ENV HTTPD_VERSION=2.4.25 \
    NAME=httpd \
    VERSION=0 \
    RELEASE=1 \
    ARCH=x86_64

LABEL MAINTAINER Rado Pitonak <rpitonak@redhat.com>

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

COPY README.md /

COPY repos/* /etc/yum.repos.d/

#install httpd service without documentation and clean cache
#TODO remove hack with sed
RUN sed -i 's|/jkaluza/|/ralph/|g' /etc/yum.repos.d/build.repo && \
    microdnf --nodocs --enablerepo httpd install httpd && \
    microdnf clean all

# add configuration file for web server
COPY files/httpdconf.sed /tmp/httpdconf.sed

# add run script
ADD files/run-httpd /usr/bin/run-httpd

RUN chmod -R a+rwx /etc/httpd && \
    sed -i -f /tmp/httpdconf.sed /etc/httpd/conf/httpd.conf && \
    useradd -r -g 0 -d ${HOME} -s /sbin/nologin \
    -c "Default Application User" default && \
    chmod -R a+rwx /var/www/ && \
    chmod -R a+rwx /usr/bin/run-httpd && \
    chmod -R a+rwx /run/httpd


# VOLUME instruction creates unnamed volume and mounts it to the provided path,
# you can override this behavior by mounting
# a selected host directory into container: "-v <host_directory>:<container_directory>"
VOLUME /var/www/
VOLUME /etc/httpd/conf/

USER 1001

# EXPOSE instruction exposes port from container to host.
# Specify it during `docker run` as parameter: "-p <host_port>:<container_port>"
EXPOSE 80
EXPOSE 443
EXPOSE 8080

# Command which will start httpd service during command `docker run`
CMD /usr/bin/run-httpd

FROM rpitonak/base-runtime

# add configuration file
ADD files/httpd.conf /etc/httpd/conf/httpd.conf
#ADD examples/html /var/www/html

# add run script
ADD files/run-script.sh /run-script.sh

# make file executable
RUN chmod +x run-script.sh

# expose ports
EXPOSE 80

CMD /bin/sh /run-script.sh

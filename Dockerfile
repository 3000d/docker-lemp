#e phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.12
MAINTAINER 'Edwin Joassart <edwin@3kd.be>'

#some scripts and techniques are borowed from Ryan Seto <ryanseto@yak.net> https://github.com/Painted-Fox/docker-mariadb/

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://mariadb.cu.be/repo/10.0/ubuntu trusty main'
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y pwgen inotify-tools
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y --force-yes nginx php5-fpm mariadb-server mariadb-server-10.0 php5-mysql php5-gd
RUN mkdir /etc/service/php5-fpm
RUN mkdir /etc/service/mariadb
RUN mkdir /etc/service/nginx
ADD scripts/php5-fpm.sh /etc/service/php5-fpm/run
ADD scripts/nginx.sh /etc/service/nginx/run
ADD scripts/mariadb.sh /etc/service/mariadb/run
RUN chmod +x /etc/service/*/*
ADD nginx.conf /etc/nginx/nginx.conf
ADD scripts /scripts
RUN chmod +x /scripts/*
ADD virtualhost.conf /etc/nginx/sites-enabled/default
RUN chown -R mysql:mysql /var/lib/mysql
RUN touch /var/log/php5-fpm.log
RUN chown www-data /var/log/php5-fpm.log
RUN sed -i -e 's/^innodb_buffer_pool_size\s*=.*/innodb_buffer_pool_size = 128M/' /etc/mysql/my.cnf
RUN sed -i -e 's/^datadir\s*=.*/datadir = \/data/' /etc/mysql/my.cnf
RUN touch /firstrun
RUN /usr/sbin/enable_insecure_key
ADD www /var/www
EXPOSE 80
EXPOSE 443

VOLUME /var/www
VOLUME /etc/nginx/sites-enabled
VOLUME ["/data", "/var/log/mysql", "/etc/mysql"]
VOLUME /var/log
RUN chown mysql:mysql /data
RUN chown www-data:www-data /var/www

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]

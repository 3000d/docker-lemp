docker-lemp LEMP stack for docker
=

* Some inspiration and some scripts are from Ryan Seto's <ryanseto@yak.net> docker mariadb build : https://github.com/Painted-Fox/docker-mariadb/
* Image build on top of phusion's baseimage-docker https://github.com/phusion/baseimage-docker 

CONFIGURATIONS
-
* virtualhost.conf => /etc/nginx/sites-enabled/default
* nginx.conf => /etc/nginx/nginx.conf
* www => /var/www

BUILD
-
* docker build -t *name*:lemp:v1.0.0

RUN
-
* docker run --name='lemp' -p 80:80 edwin3000/lemp

VOLUMES
-
* /data
* /etc/mysql
* /etc/nginx/sites-enabled
* /var/log
* /var/www

#!/bin/sh
exec /usr/sbin/php5-fpm -F >>/var/log/php5-fpm.log 2>&1

#!/bin/sh
set -x
set -e

ln -s /etc/lemonldap-ng/handler-nginx.conf /etc/nginx/sites-available/
ln -s /etc/lemonldap-ng/manager-nginx.conf /etc/nginx/sites-available/
ln -s /etc/lemonldap-ng/portal-nginx.conf /etc/nginx/sites-available/
ln -s /etc/lemonldap-ng/test-nginx.conf /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/handler-nginx.conf /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/manager-nginx.conf /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/portal-nginx.conf /etc/nginx/sites-enabled/
ln -s /etc/nginx/sites-available/test-nginx.conf /etc/nginx/sites-enabled/

exec /usr/sbin/llng-fastcgi-server -F -u www-data -g www-data

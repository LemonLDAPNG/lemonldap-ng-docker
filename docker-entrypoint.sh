#!/bin/sh
service cron start
service anacron start
sed -i "s/example\.com/${SSODOMAIN}/" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json

sed -i -e "s/^logLevel.*/logLevel=${LOGLEVEL}\nlogger     = Lemonldap::NG::Common::Logger::Std/" /etc/lemonldap-ng/lemonldap-ng.ini
sed -i -e 's/^;checkTime.*/checkTime = 1/' /etc/lemonldap-ng/lemonldap-ng.ini

# Run the fastcgi server withing this session so that we can get logs in 
# STDOUT/STDERR
. /etc/default/lemonldap-ng-fastcgi-server
export SOCKET PID USER GROUP

mkdir "$(dirname $SOCKET)"
chown www-data "$(dirname $SOCKET)"
/usr/sbin/llng-fastcgi-server --foreground&

nginx

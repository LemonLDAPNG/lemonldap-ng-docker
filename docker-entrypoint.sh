#!/bin/sh
service cron start
service anacron start
sed -i "s/example\.com/${SSODOMAIN}/" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json

sed -i -e "s/^logLevel.*/logLevel=${LOGLEVEL}\nlogger     = Lemonldap::NG::Common::Logger::Std/" /etc/lemonldap-ng/lemonldap-ng.ini
sed -i -e 's/^;checkTime.*/checkTime = 1/' /etc/lemonldap-ng/lemonldap-ng.ini

if [ ! -z ${FASTCGI_LISTEN_PORT+x} ]; then
    # Remove the SOCKET variable
    sed -i -e "s|^SOCKET=/run/llng-fastcgi-server/llng-fastcgi.sock|#SOCKET=/run/llng-fastcgi-server/llng-fastcgi.sock|" /etc/default/lemonldap-ng-fastcgi-server
    
    # Add LISTEN variable
    echo "# Listen" >> /etc/default/lemonldap-ng-fastcgi-server
    echo "LISTEN=0.0.0.0:$FASTCGI_LISTEN_PORT" >> /etc/default/lemonldap-ng-fastcgi-server

    # Update NGinx configuration from UNIX socket to TCP socket
    sed -i -e "s|fastcgi_pass unix:/var/run/llng-fastcgi-server/llng-fastcgi.sock|fastcgi_pass 0.0.0.0:$FASTCGI_LISTEN_PORT|" /etc/lemonldap-ng/*-nginx.conf
fi

. /etc/default/lemonldap-ng-fastcgi-server
export SOCKET LISTEN PID USER GROUP

if [ ! -z ${SOCKET+x} ]; then
mkdir "$(dirname $SOCKET)"
chown www-data "$(dirname $SOCKET)"
fi

# Run the fastcgi server withing this session so that we can get logs in 
# STDOUT/STDERR
/usr/sbin/llng-fastcgi-server --foreground&

nginx

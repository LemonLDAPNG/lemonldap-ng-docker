#!/bin/sh
service cron start
service anacron start

if [ ! -z ${PORT} ]; then
  echo "# Changing nginx port to ${PORT}"
  sed -i -e "s/listen 80;/listen ${PORT};/g" /etc/nginx/sites-enabled-orig/*
fi

if [ "${IPV4_ONLY}" = true ]; then
echo "# Disabling IPV6 in nginx"
  sed -i -e "/listen \[::\]:80;/d" /etc/nginx/sites-enabled-orig/*
fi

for PRESERVEFILE in ${PRESERVEFILES} ;
do
    if [ ! "$(ls -A ${PRESERVEFILE} &>/dev/null)" ]; then
        echo "# Restore ${PRESERVEFILE} directory"
        chown -R www-data:www-data ${PRESERVEFILE}
        cp -a ${PRESERVEFILE}-orig/* ${PRESERVEFILE}/
    fi
done

if [ ! -z ${PORTAL_HOSTNAME+x} ]; then
    sed -i -e "s/auth.example.com/${PORTAL_HOSTNAME}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json
fi
if [ ! -z ${MANAGER_HOSTNAME+x} ]; then
    sed -i -e "s/manager.example.com/${MANAGER_HOSTNAME}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json
fi
if [ ! -z ${HANDLER_HOSTNAME+x} ]; then
    sed -i -e "s/reload.example.com/${HANDLER_HOSTNAME}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json
fi
if [ ! -z ${TEST1_HOSTNAME+x} ]; then
    sed -i -e "s/test1.example.com/${TEST1_HOSTNAME}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json
fi
if [ ! -z ${TEST2_HOSTNAME+x} ]; then
    sed -i -e "s/test2.example.com/${TEST2_HOSTNAME}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json
fi

if [ ! -z ${PROXY_RANGE+x} ]; then
    sed -i -e "s#.*set_real_ip_from.*#  set_real_ip_from ${PROXY_RANGE};#g" /etc/nginx/sites-enabled/*
    sed -i -e "s#.*real_ip_header.*#  real_ip_header    X-Forwarded-For;#g" /etc/nginx/sites-enabled/*
fi

sed -i "s/\.example\.com/\.${SSODOMAIN}/" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json /etc/nginx/sites-enabled/*

# Logging options
sed -i -e "s/^logLevel.*/logLevel=${LOGLEVEL}/" /etc/lemonldap-ng/lemonldap-ng.ini
if ! grep -q '^logger' /etc/lemonldap-ng/lemonldap-ng.ini ; then
    sed -i -e '/^logLevel/alogger = Lemonldap::NG::Common::Logger::Std' /etc/lemonldap-ng/lemonldap-ng.ini
fi

sed -i -e 's/^;checkTime.*/checkTime = 1/' /etc/lemonldap-ng/lemonldap-ng.ini

if [ ! -z ${FASTCGI_LISTEN_PORT+x} ]; then
    echo "Remove the SOCKET variable"
    sed -i -e "s|^SOCKET=/run/llng-fastcgi-server/llng-fastcgi.sock|#SOCKET=/run/llng-fastcgi-server/llng-fastcgi.sock|" /etc/default/lemonldap-ng-fastcgi-server

    echo "Add LISTEN variable"
    echo "# Listen" >> /etc/default/lemonldap-ng-fastcgi-server
    echo "LISTEN=0.0.0.0:$FASTCGI_LISTEN_PORT" >> /etc/default/lemonldap-ng-fastcgi-server

    echo "Update NGinx configuration from UNIX socket to TCP socket"
    sed -i -e "s|fastcgi_pass unix:/var/run/llng-fastcgi-server/llng-fastcgi.sock|fastcgi_pass 0.0.0.0:$FASTCGI_LISTEN_PORT|" /etc/nginx/sites-enabled/*-nginx.conf

    echo "Update upstream llng fastcgi to tcpsocket"
    sed -i -e "s|unix:/var/run/llng-fastcgi-server/llng-fastcgi.sock|0.0.0.0:$FASTCGI_LISTEN_PORT|" /etc/nginx/sites-enabled/portal-nginx.conf

    echo "Exporting environment variables"
    . /etc/default/lemonldap-ng-fastcgi-server
    export SOCKET LISTEN PID USER GROUP

    echo "Starting fast-cgi-server"
    /etc/init.d/lemonldap-ng-fastcgi-server start
else
    echo "Exporting environment variables"
    . /etc/default/lemonldap-ng-fastcgi-server
    export SOCKET LISTEN PID USER GROUP

    echo "Creating directory for socket"
    if [ ! -z ${SOCKET+x} ]; then
        mkdir -p "$(dirname $SOCKET)"
        chown www-data "$(dirname $SOCKET)"
    fi

    echo "Starting fast-cgi-server"
    /usr/sbin/llng-fastcgi-server --foreground&
fi

echo "Starting nginx"
nginx

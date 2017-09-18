#!/bin/bash

if [ "$SSODOMAIN" != 'example.com' ]; then
    echo "Work in progress $SSODOMAIN"
fi

echo "ServerName $SSODOMAIN" >> /etc/httpd/httpd.conf

sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* \
    /var/lib/lemonldap-ng/conf/lmConf-1.js* /var/lib/lemonldap-ng/test/index.pl

exec "$@"

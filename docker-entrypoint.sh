#!/bin/bash

if [ "$SSODOMAIN" != 'example.com' ]; then
    echo "Work in progress $SSODOMAIN"
fi

echo "ServerName $SSODOMAIN" >> /etc/apache2/apache2.conf

sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* \
    /var/lib/lemonldap-ng/conf/lmConf-1.js* /var/lib/lemonldap-ng/test/index.pl

find /etc/apache2/sites-available/ -name '*.conf' ! -name '000-default.conf' \
     -exec ln -sf {} /etc/apache2/sites-enabled/ \;
find /vhosts/ -name '*.conf' \
     -exec ln -sf {} /etc/apache2/sites-enabled/ \;

exec "$@"

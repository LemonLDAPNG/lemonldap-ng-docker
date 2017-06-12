#!/bin/bash

if [ "$SSODOMAIN" != 'example.com' ]; then
    echo "Traitement de $SSODOMAIN"
fi

sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* \
    /var/lib/lemonldap-ng/conf/lmConf-1.js /var/lib/lemonldap-ng/test/index.pl
sed -i 's/CGIPassAuth on/#CGIPassAuth on/g' \
    /etc/lemonldap-ng/portal-apache2.conf

find /etc/apache2/sites-available/ -name '*.conf' ! -name '000-default.conf' \
     -exec ln -s {} /etc/apache2/sites-enabled/ \;
find /vhosts/ -name '*.conf' \
     -exec ln -s {} /etc/apache2/sites-enabled/ \;

exec "$@"

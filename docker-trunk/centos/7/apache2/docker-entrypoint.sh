#!/bin/sh

if [ "$SSODOMAIN" != 'example.com' ]; then
    HTTPCONF=/etc/httpd/conf.d/httpd.conf
    if ! grep "ServerName $SSODOMAIN" "$HTTPCONF" >/dev/null; then
	echo "Configuring LLNG for $SSODOMAIN"
	echo "ServerName $SSODOMAIN" >>"$HTTPCONF"
	sed -i "s/example\.com/$SSODOMAIN/g" /etc/lemonldap-ng/* \
	    /var/lib/lemonldap-ng/conf/lmConf-1.js* /var/lib/lemonldap-ng/test/index.pl
    else
	echo "Re-using LLNG existing configuration for $SSODOMAIN"
    fi
fi

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND

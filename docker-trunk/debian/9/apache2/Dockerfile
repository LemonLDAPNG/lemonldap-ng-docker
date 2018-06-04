# Dockerfile for LemonLDAP::NG
# Installation of trunk version of LL::NG

# Start from Debian Jessie
FROM debian:stretch
MAINTAINER Clément OUDOT
LABEL name="llng-apache2-trunk" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com

RUN apt -y update \
    && apt -y upgrade \
    && apt-get -y install gnupg2 curl
RUN apt -y update \
    && apt -y upgrade \
    && apt-get -y install gnupg2 curl \
    && curl http://lemonldap-ng.ow2.io/lemonldap-ng/GPG_PUBLIC_KEY | apt-key add - \
    && echo 'deb [arch=amd64,trusted=yes] http://lemonldap-ng.ow2.io/lemonldap-ng/debian stretch main' > /etc/apt/sources.list.d/llng.list \
    && apt -y update \
    && apt-get -y install apache2 libapache2-mod-perl2 libapache2-mod-fcgid lemonldap-ng libgd-securityimage-perl \
    && sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* \
    && echo "/var/lib/lemonldap-ng/conf/lmConf-1.js" \
    && sed -i "s/logLevel\s*=\s*warn/logLevel = debug/" /etc/lemonldap-ng/lemonldap-ng.ini \
    && sed -i "s/LogLevel warn/LogLevel debug/" /etc/apache2/apache2.conf \
    && a2ensite handler-apache2.conf portal-apache2.conf manager-apache2.conf test-apache2.conf \
    && a2enmod fcgid perl alias rewrite headers \
    && rm -rf /tmp/lemonldap-ng-config \
    && rm -fr /var/lib/apt/lists/*

EXPOSE 80 443
VOLUME ["/var/log/apache2", "/etc/apache2", "/etc/lemonldap-ng", "/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

# Dockerfile for LemonLDAP::NG
# Use debian repo of LemonLDAP::NG project

# Start from Debian Jessie
FROM debian:jessie
MAINTAINER Clément OUDOT
LABEL name="k8s-llng-apache2" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com 
ENV DUMBINITVERSION 1.2.0

EXPOSE 80 443
COPY etc.apt.sources.d.lemonldap-ng.list /

# Update system
RUN apt -y update \
    && apt -y install wget apt-transport-https \
    && apt -y dist-upgrade  \
    && echo "# Install Dumb-init" \
    && wget https://github.com/Yelp/dumb-init/releases/download/v${DUMBINITVERSION}/dumb-init_${DUMBINITVERSION}_amd64.deb \
    && dpkg -i dumb-init_${DUMBINITVERSION}_amd64.deb \
    && apt install -f -y \
    && echo "# Install LemonLDAP::NG repo" \
    && mv etc.apt.sources.d.lemonldap-ng.list /etc/apt/sources.list.d/lemonldap-ng.list \
    && wget -O - http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - \
    && apt update \
    && echo "# Install LemonLDAP::NG package" \
    && apt -y install apache2 libapache2-mod-perl2 libapache2-mod-fcgid lemonldap-ng lemonldap-ng-fr-doc \
    && echo "# Change SSO Domain" \
    && sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.js /var/lib/lemonldap-ng/test/index.pl \
    && echo "# Comment CGIPassAuth directive" \
    && sed -i 's/CGIPassAuth on/#CGIPassAuth on/g' /etc/lemonldap-ng/portal-apache2.conf \
    && echo "# Enable sites" \
    && a2ensite handler-apache2.conf \ 
    && a2ensite portal-apache2.conf \
    && a2ensite manager-apache2.conf \
    && a2ensite test-apache2.conf \
    && a2enmod fcgid perl alias rewrite \
    && echo "# Remove cached configuration" \
    && rm -rf /tmp/lemonldap-ng-config \ 
    && rm -fr /var/lib/apt/lists/*

VOLUME ["/var/log/apache2", "/etc/apache2", "/etc/lemonldap-ng", "/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]
ENTRYPOINT ["dumb-init","--","/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

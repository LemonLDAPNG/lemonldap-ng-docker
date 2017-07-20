# Dockerfile for LemonLDAP::NG
# Use debian repo of LemonLDAP::NG project

# Start from Debian Jessie
FROM debian:jessie
MAINTAINER Clément OUDOT
LABEL name="k8s-llng-fastcgi" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com 
ENV DUMBINITVERSION 1.2.0

COPY etc.apt.sources.d.lemonldap-ng.list /
COPY entrypoint.sh /

# Update system
RUN apt -y update \
    && apt -y install wget apt-transport-https \
    && apt -y dist-upgrade  \
    && echo "# Install Dumb-init" \
    && wget https://github.com/Yelp/dumb-init/releases/download/v${DUMBINITVERSION}/dumb-init_${DUMBINITVERSION}_amd64.deb \
    && dpkg -i dumb-init_${DUMBINITVERSION}_amd64.deb \
    && apt install -f -y \
    && rm -f dumb-init_${DUMBINITVERSION}_amd64.deb \
    && echo "# Install LemonLDAP::NG repo" \
    && mv etc.apt.sources.d.lemonldap-ng.list /etc/apt/sources.list.d/lemonldap-ng.list \
    && wget -O - http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - \
    && apt update \
    && echo "# Install LemonLDAP::NG package" \
    && apt -y install  lemonldap-ng lemonldap-ng-fr-doc lemonldap-ng-fastcgi-server \
    && echo "# Change SSO Domain" \
    && sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/* \
    && echo "# Remove cached configuration" \
    && rm -rf /tmp/lemonldap-ng-config \ 
    && rm -fr /var/lib/apt/lists/*

ENTRYPOINT ["dumb-init","--","/bin/sh","/entrypoint.sh"]


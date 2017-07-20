# Dockerfile for LemonLDAP::NG
# Use debian repo of LemonLDAP::NG project

# Start from Debian Jessie
FROM debian:jessie
MAINTAINER Clément OUDOT
LABEL name="llng-apache2" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com \
    DUMBINITVERSION 1.2.0

COPY lemonldap-ng.list /

# Update system
RUN apt -y update \
    && apt -y install wget apt-transport-https \
    && apt -y dist-upgrade  \
    && echo "# Install Dumb-init" \
    && wget https://github.com/Yelp/dumb-init/releases/download/v${DUMBINITVERSION}/dumb-init_${DUMBINITVERSION}_amd64.deb \
    && dpkg -i dumb-init_${DUMBINITVERSION}_amd64.deb \
    && apt install -f -y \
    && echo "# Install LemonLDAP::NG package" \
    && apt -y install  \
    && apt clean \
    && rm -fr /var/lib/apt/lists/*

EXPOSE 80 443
ENTRYPOINT ["dumb-init","--","/usr/sbin/nginx"]

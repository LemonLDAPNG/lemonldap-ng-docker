# Start from Debian Jessie
FROM debian:jessie
MAINTAINER Clément OUDOT

# Change SSO DOMAIN here
ENV SSODOMAIN example.com

# Update system
RUN apt-get -y update && apt-get -y dist-upgrade

# Install LemonLDAP::NG repo
RUN apt-get -y install wget apt-transport-https
RUN wget -O - http://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add -

RUN echo "deb https://lemonldap-ng.org/deb stable main" > /etc/apt/sources.list.d/lemonldap-ng.list
RUN echo "deb-src https://lemonldap-ng.org/deb stable main" >> /etc/apt/sources.list.d/lemonldap-ng.list

# Install LemonLDAP::NG packages
RUN apt-get -y update
RUN apt-get -y install apache2 libapache2-mod-perl2 libapache2-mod-fcgid lemonldap-ng lemonldap-ng-fr-doc

RUN a2enmod fcgid perl alias rewrite
RUN rm -rf /tmp/lemonldap-ng-config
RUN mkdir /vhosts

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 80 443

CMD "/usr/sbin/apache2ctl" "-D" "FOREGROUND"

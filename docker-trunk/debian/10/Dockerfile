FROM debian:buster
MAINTAINER Xavier (Yadd) Guimard
LABEL name="lemonldap-ng-nginx" \
      version="v2.0.0~a1"

ENV SSODOMAIN=example.com \
    PORTAL=http://auth.example.com \
    PORT= \
    DUMBINITVERSION=1.2.0 \
    DEBIAN_FRONTEND=noninteractive

EXPOSE 80 443
RUN apt-get -y update \
    && apt-get -y dist-upgrade

RUN echo "# Install LemonLDAP::NG source repo" && \
    apt-get -y install wget apt-transport-https gnupg liblasso-perl && \
    wget -O - https://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - && \
    echo "deb     https://lemonldap-ng.org/deb 2.0 main" >/etc/apt/sources.list.d/lemonldap-ng.list

RUN echo "# Install Dumb-init" \
    && wget https://github.com/Yelp/dumb-init/releases/download/v${DUMBINITVERSION}/dumb-init_${DUMBINITVERSION}_amd64.deb \
    && dpkg -i dumb-init_${DUMBINITVERSION}_amd64.deb \
    && apt-get install -f -y \
    && apt-get -y update \
    && echo "# Install LemonLDAP::NG package" \
    && apt-get -y install nginx lemonldap-ng cron anacron \
    && echo "LLNG installed"

RUN echo "#!/bin/sh" > /usr/bin/start.sh && \
    echo "service cron start" >> /usr/bin/start.sh && \
    echo "service anacron start" >> /usr/bin/start.sh && \
    echo 'perl -i -pe '"'"'s@http://auth.example.com/@$ENV{PORTAL}@g'"' /var/lib/lemonldap-ng/conf/lmConf-1.json" >> /usr/bin/start.sh && \
    echo 'perl -i -pe '"'"'s@example.com/@$ENV{SSODOMAIN}$ENV{PORT}/@g'"' /var/lib/lemonldap-ng/conf/lmConf-1.json" >> /usr/bin/start.sh && \
    echo 'sed -i "s/example\.com/${SSODOMAIN}/" /etc/lemonldap-ng/* /var/lib/lemonldap-ng/conf/lmConf-1.json' >> /usr/bin/start.sh && \
    echo "service lemonldap-ng-fastcgi-server start" >> /usr/bin/start.sh && \
    echo "nginx" >> /usr/bin/start.sh && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
    chmod +x /usr/bin/start.sh && \
    echo "start script created"

RUN cd /etc/nginx/sites-enabled/ && \
    ln -s ../../lemonldap-ng/handler-nginx.conf && \
    ln -s ../../lemonldap-ng/portal-nginx.conf && \
    ln -s ../../lemonldap-ng/manager-nginx.conf && \
    ln -s ../../lemonldap-ng/test-nginx.conf && \
    echo "LLNG conf files installed"

CMD [ "start.sh" ]

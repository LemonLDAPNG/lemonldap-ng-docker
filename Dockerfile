FROM debian:stable-slim
LABEL   org.opencontainers.image.authors="Clément OUDOT" \
        name="lemonldap-ng-nginx" \
        version="v2.0"

ENV SSODOMAIN=example.com \
    LOGLEVEL=info \
    DEBIAN_FRONTEND=noninteractive

# Keep documentation files for Lemonldap that are normally removed by the
# debian-slim image
COPY lemonldap.dpkg.cfg /etc/dpkg/dpkg.cfg.d/lemonldap

RUN echo "# Install LemonLDAP::NG source repo" && \
    apt -y update && \
    apt -y install wget apt-transport-https gnupg dumb-init && \
    wget -O - https://lemonldap-ng.org/_media/rpm-gpg-key-ow2 | apt-key add - && \
    echo "deb https://lemonldap-ng.org/deb 2.0 main" >/etc/apt/sources.list.d/lemonldap-ng.list

RUN echo "# Enable Debian backports" && \
    echo "deb http://deb.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/backports.list

RUN apt -y update && \
    echo "# Install LemonLDAP::NG packages" && \
    apt -y install nginx lemonldap-ng cron anacron liblasso-perl libio-string-perl && \
    echo "# Install LemonLDAP::NG TOTP requirements" && \
    apt -y install libconvert-base32-perl libdigest-hmac-perl && \
    echo "# Install LemonLDAP::NG WebAuthn requirements" && \
    apt -y install libauthen-webauthn-perl && \
    echo "# Install some DB drivers" && \
    apt -y install libdbd-mysql-perl libdbd-pg-perl && \
    echo "# Install vim required for lmConfigEditor" && \
    apt -y install vim && \
    echo "\ndaemon off;" >> /etc/nginx/nginx.conf

RUN echo "# Clean up image" && \
    apt clean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/

COPY docker-entrypoint.sh /

RUN echo '# Copy orignal configuration' && \
    cp -a /etc/lemonldap-ng /etc/lemonldap-ng-orig && \
    cp -a /var/lib/lemonldap-ng/conf /var/lib/lemonldap-ng/conf-orig && \
    cp -a /var/lib/lemonldap-ng/sessions /var/lib/lemonldap-ng/sessions-orig && \
    cp -a /var/lib/lemonldap-ng/psessions /var/lib/lemonldap-ng/psessions-orig

RUN echo "# Reverse proxy clean up" && \
    rm /etc/lemonldap-ng-orig/*-apache2.conf && \
    rm /etc/nginx/sites-enabled/default && \
    mkdir /etc/nginx/sites-enabled-orig && \
    mv /etc/lemonldap-ng-orig/*-nginx.conf /etc/nginx/sites-enabled-orig/

RUN echo "# Configure nginx to log to standard streams" && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/etc/lemonldap-ng","/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]

ENTRYPOINT ["dumb-init","--","/bin/sh", "/docker-entrypoint.sh"]

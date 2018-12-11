# Dockerfile for LemonLDAP::NG
# Installation of trunk version of LL::NG

# Start from Debian Jessie
FROM debian:jessie
MAINTAINER Xavier Guimard
LABEL name="llng-nginx-trunk" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com 
ENV  DUMBINITVERSION 1.2.0

COPY etc.supervisor.conf.d.supervisord.conf /

# Update system and install LL::NG dependencies
RUN echo "deb http://ftp.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list \
    && apt-get -y update \
    && apt -y install wget apt-transport-https \
    && apt -y dist-upgrade  \
    && echo "# Install Dumb-init" \
    && wget https://github.com/Yelp/dumb-init/releases/download/v${DUMBINITVERSION}/dumb-init_${DUMBINITVERSION}_amd64.deb \
    && dpkg -i dumb-init_${DUMBINITVERSION}_amd64.deb \
    && apt install -f -y \
    && apt-get -y install nginx-extras supervisor libapache-session-perl libnet-ldap-perl \
	libcache-cache-perl libdbi-perl perl-modules libwww-perl libcache-cache-perl \
	libxml-simple-perl  libsoap-lite-perl libhtml-template-perl \
	libregexp-assemble-perl libjs-jquery libxml-libxml-perl libcrypt-rijndael-perl \
	libio-string-perl libxml-libxslt-perl libconfig-inifiles-perl libjson-perl \
	libstring-random-perl libemail-date-format-perl libmime-lite-perl \
	libcrypt-openssl-rsa-perl libdigest-hmac-perl libclone-perl libauthen-sasl-perl \
	libnet-cidr-lite-perl libcrypt-openssl-x509-perl libauthcas-perl libtest-pod-perl \
	libtest-mockobject-perl libauthen-captcha-perl libnet-openid-consumer-perl \
	libnet-openid-server-perl libunicode-string-perl libconvert-pem-perl \
	libmouse-perl libplack-perl libglib-perl liblasso-perl yui-compressor dh-systemd \
	vim git make devscripts libdbd-sqlite3-perl libemail-sender-perl \
	libgd-securityimage-perl libimage-magick-perl libconvert-base32-perl \
	&& apt-get install -y -t jessie-backports debhelper \
    && rm -rf /var/lib/apt/lists/* \
    && echo "# Get trunk version of LL::NG" \
    && cd /root \
    && git clone https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng.git \
    && echo "# Install LL::NG" \
    && cd lemonldap-ng \
    && make debian-install-for-nginx \
    && rm -rf /tmp/*lemonldap* /root/lemonldap/* \
    && mv /etc.supervisor.conf.d.supervisord.conf /etc/supervisor/conf.d/supervisord.conf \
    && echo "# Change SSO Domain" \
    && sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/*  /var/lib/lemonldap-ng/test/index.pl \
    && echo "#/var/lib/lemonldap-ng/conf/lmConf-1.js" \
    && echo "# Set debug mode" \
    && sed -i "s/logLevel\s*=\s*warn/logLevel = debug/" /etc/lemonldap-ng/lemonldap-ng.ini \
    && echo "# Enable sites" \
    && cd /etc/nginx/sites-enabled \
    && ln -s ../sites-available/portal-nginx.conf \
    && ln -s ../sites-available/manager-nginx.conf \
    && ln -s ../sites-available/handler-nginx.conf \
    && ln -s ../sites-available/test-nginx.conf \
    && echo "# Enable headers and custom logs" \
    && perl -i -pe 's/#// if(/nginx-lua-headers/)' /etc/lemonldap-ng/test-nginx.conf \
    && perl -i -pe 's/#// if(/access\.log/)' /etc/lemonldap-ng/handler-nginx.conf \
    && echo "# No daemon" \
    && echo "\ndaemon off;" >> /etc/nginx/nginx.conf \
	&& echo "# Create run directory for llng-fastcgi-server" \
	&& mkdir -p /var/run/llng-fastcgi-server/ \
	&& chown www-data:www-data /var/run/llng-fastcgi-server/

EXPOSE 80 443
VOLUME ["/var/log/nginx", "/etc/lemonldap-ng", "/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]
ENTRYPOINT ["dumb-init","--","/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

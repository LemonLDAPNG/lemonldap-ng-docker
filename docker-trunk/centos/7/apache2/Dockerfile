# Dockerfile for LemonLDAP::NG
# Installation of trunk version of LL::NG

# Start from Debian Jessie
FROM centos:latest 
MAINTAINER Clément OUDOT
LABEL name="llng-apache2-trunk" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com

# Update system
RUN yum -y update \
    && yum -y install httpd libapache2-mod-perl2 libapache2-mod-fcgid \
        libapache-session-perl libnet-ldap-perl libcache-cache-perl \
        libdbi-perl perl-modules libwww-perl libcache-cache-perl \
        libxml-simple-perl  libsoap-lite-perl libhtml-template-perl \
        libregexp-assemble-perl libjs-jquery libxml-libxml-perl \
        libcrypt-rijndael-perl libio-string-perl libxml-libxslt-perl \
        libconfig-inifiles-perl libjson-perl libstring-random-perl \
        libemail-date-format-perl libmime-lite-perl libcrypt-openssl-rsa-perl \
        libdigest-hmac-perl libclone-perl libauthen-sasl-perl \
        libnet-cidr-lite-perl libcrypt-openssl-x509-perl libauthcas-perl \
        libtest-pod-perl libtest-mockobject-perl libauthen-captcha-perl \
        libnet-openid-consumer-perl libnet-openid-server-perl \
        libunicode-string-perl libconvert-pem-perl libmouse-perl libplack-perl \
        libglib-perl liblasso-perl yui-compressor dh-systemd libdbd-sqlite3-perl \
        libemail-sender-perl libgd-securityimage-perl libimage-magick-perl \
    && yum -y install vim \
    && yum -y install subversion make devscriptsi rpm-build \
    && cd /root \
    && svn co svn://svn.forge.objectweb.org/svnroot/lemonldap/trunk lemonldap \
    && cd lemonldap \
    && make rpm-dist \
    && VERSION=$(grep 'stable' changelog   | head -n 1 | awk '{ print $2 }' | sed -e 's/(//g' -e 's/)//g') \
    && rpmbuild -ta lemonldap-ng-${VERSION}.tar.gz 
#    && sed -i "s/example\.com/${SSODOMAIN}/g" /etc/lemonldap-ng/*  /var/lib/lemonldap-ng/test/index.pl \
#    && echo "/var/lib/lemonldap-ng/conf/lmConf-1.js" \
#    && sed -i "s/logLevel\s*=\s*warn/logLevel = debug/" /etc/lemonldap-ng/lemonldap-ng.ini \
#    && sed -i "s/LogLevel warn/LogLevel debug/" /etc/apache2/apache2.conf \
#    && a2ensite handler-apache2.conf portal-apache2.conf manager-apache2.conf test-apache2.conf \
#    && a2enmod fcgid perl alias rewrite \
#    && rm -rf /tmp/lemonldap-ng-config \
#    && rm -fr /var/lib/apt/lists/*

EXPOSE 80 443
VOLUME ["/var/log/apache2", "/etc/httpd", "/etc/lemonldap-ng", "/var/lib/lemonldap-ng/conf", "/var/lib/lemonldap-ng/sessions", "/var/lib/lemonldap-ng/psessions"]
ENTRYPOINT ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

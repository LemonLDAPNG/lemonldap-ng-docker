# Dockerfile for LemonLDAP::NG
# Installation of trunk version of LL::NG

# Start from CentOS 7
FROM centos:7
MAINTAINER Clément OUDOT
LABEL name="llng-centos7-apache2-trunk" \
      version="v0.0.1"

# Change SSO DOMAIN here
ENV SSODOMAIN example.com

EXPOSE 80 443

COPY docker-entrypoint.sh /

# Update and install
RUN yum -y update \
    && yum clean all \
    && curl -fLsS -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 \
    && chmod +x /usr/local/bin/dumb-init \
    && yum -y install epel-release \
    && yum -y install perl-Apache-Session perl-Authen-Captcha perl-Cache-Cache perl-Clone perl-Config-IniFiles perl-Convert-PEM perl-Crypt-OpenSSL-RSA perl-Crypt-OpenSSL-X509 perl-Crypt-Rijndael perl-Digest-HMAC perl-Digest-SHA perl-Email-Sender perl-GD-SecurityImage perl-HTML-Template perl-IO-String perl-JSON perl-LDAP perl-Mouse perl-Plack perl-Regexp-Assemble perl-Regexp-Common perl-SOAP-Lite perl-String-Random perl-Unicode-String perl-version perl-XML-Simple --enablerepo=epel-testing \
    && yum -y install perl-Test-Pod perl-Class-Inspector perl-Test-MockObject perl-Env perl-XML-LibXSLT \
    && yum -y install git rpm-build tar which

# Get trunk version of LL::NG
WORKDIR root
RUN git clone https://gitlab.ow2.org/lemonldap-ng/lemonldap-ng.git \
    && cd lemonldap-ng \
    && make rpm-dist \
    && rpmbuild -ta lemonldap*tar.gz

# Install packages
RUN yum localinstall -y /root/rpmbuild/RPMS/noarch/*.rpm \
    && yum clean all \
    && rpm -Uvh --force /root/rpmbuild/RPMS/noarch/lemonldap-ng-doc*rpm

ENTRYPOINT ["/usr/local/bin/dumb-init","--","/docker-entrypoint.sh"]

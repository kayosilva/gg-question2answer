FROM ubuntu:20.04

ENV UBUNTU_CODENAME="focal"
ENV PHP_VERSION="8.0"
ENV DEBIAN_FRONTEND="noninteractive"
ENV APACHE_RUN_DIR="/etc/apache2"
ENV APACHE_PID_FILE="/var/run/apache2/apache2"
ENV APACHE_RUN_USER="www-data"
ENV APACHE_RUN_GROUP="www-data"
ENV APACHE_LOG_DIR="/var/log/apache2"

#####
# Install base
#####
RUN apt-get update
RUN apt-get install --assume-yes --no-install-recommends --no-install-suggests \
    apache2 \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    ssl-cert

RUN make-ssl-cert generate-default-snakeoil --force-overwrite

#####
# Install PHP
#####
RUN echo "deb http://ppa.launchpad.net/ondrej/apache2/ubuntu ${UBUNTU_CODENAME} main" >> /etc/apt/sources.list
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu ${UBUNTU_CODENAME} main" >> /etc/apt/sources.list

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update
RUN apt-get install --assume-yes --no-install-recommends --no-install-suggests \
    libapache2-mod-php${PHP_VERSION} \
    php${PHP_VERSION}-apcu \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-bz2 \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-msgpack \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-pdo-pgsql \
    php${PHP_VERSION}-readline \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-sockets \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-yaml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-redis


RUN echo "TLS_REQCERT  allow" >> /etc/ldap/ldap.conf

RUN a2enmod rewrite
RUN  a2enmod ssl
RUN  service apache2 restart

EXPOSE 80

STOPSIGNAL SIGWINCH

CMD ["apache2", "-DFOREGROUND"]

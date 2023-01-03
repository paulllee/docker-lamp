# Author: Paul Lee
# Company: Lyquix

FROM ubuntu:18.04
LABEL author="Paul Lee @ Lyquix"

RUN apt-get update -y

# Utilities
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y \
    curl \ 
    vim \
    openssl \
    git \
    htop \
    nload \
    mytop \
    nethogs \
    zip \
    unzip \
    libcurl3-openssl-dev \
    psmisc \
    build-essential \
    zlib1g-dev \
    libpcre3 \
    libpcre3-dev \
    memcached \
    iptables-persistent \
    software-properties-common

# Apache
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y \
    apache2 \
    apache2-doc \
    apachetop \
    libapache2-mod-php \
    libapache2-mod-fcgid \
    apache2-suexec-pristine \
    libapache2-mod-security2 

# PHP
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y \
    mcrypt \
    imagemagick \
    php7.2 \
    php7.2-common \
    php7.2-gd \
    php7.2-imap \
    php7.2-mysql \
    php7.2-mysqli \
    php7.2-cli \
    php7.2-cgi \
    php7.2-zip \
    php-pear \
    php-imagick \
    php7.2-curl \
    php7.2-mbstring \
    php7.2-bcmath \
    php7.2-xml \
    php7.2-soap \
    php7.2-opcache \
    php7.2-intl \
    php-apcu \
    php-mail \
    php-mail-mime \
    php-all-dev \
    php7.2-dev \
    libapache2-mod-php7.2 \
    php7.2-memcached \
    composer

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

# www-data user
RUN mkdir /var/www; \
    chown -R www-data:www-data /var/www; \
    chsh -s /bin/bash www-data

# Apache configuration
RUN a2enmod expires; \ 
    a2enmod headers; \
    a2enmod rewrite; \
    a2enmod ssl; \
    a2enmod suphp; \  
    a2enmod mpm_prefork; \ 
    a2enmod security2

RUN service apache2 restart

COPY ./apache/apache2config .
COPY ./apache/deflateconfig .
COPY ./apache/logrotateconfig .
COPY ./apache/mimeconfig .

COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./apache/dir.conf /etc/apache2/mods-available/dir.conf
COPY ./apache/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf

COPY ./apache/apache-configuration.sh .

RUN bash apache-configuration.sh

RUN rm *config && \
    rm apache-configuration.sh

# installing ModPagespeed
RUN curl -O https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
    dpkg -i mod-pagespeed*.deb && \
    rm mod-pagespeed*.deb && \
    apt-get -f install

RUN sed -i 's/ModPagespeed on/ModPagespeed off/' /etc/apache2/mods-available/pagespeed.conf

RUN mkdir -p /srv/www/public_html && \
    mkdir -p /srv/www/logs && \
    mkdir -p /srv/www/ssl && \
    chown -R www-data:www-data /srv/www

RUN service apache2 restart

# PHP configuration
RUN sed -i 's/output_buffering = 4096/output_buffering = Off/' /etc/php/7.2/apache2/php.ini; \
    sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/7.2/apache2/php.ini; \
	sed -i 's/; max_input_vars = 1000/max_input_vars = 5000/' /etc/php/7.2/apache2/php.ini; \
    sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/7.2/apache2/php.ini; \
    sed -i 's/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/error_reporting = E_ALL \& \~E_NOTICE \& \~E_STRICT \& \~E_DEPRECATED/' /etc/php/7.2/apache2/php.ini; \
    sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/7.2/apache2/php.ini; \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/7.2/apache2/php.ini; \
    sed -i 's/Require all denied/Require all granted/g' /etc/apache2/mods-available/php7.2.conf

# ports for container to listen
EXPOSE 80

# start apache service
CMD ["apachectl", "-D", "FOREGROUND"]
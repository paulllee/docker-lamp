# Author: Paul Lee
# Company: Lyquix

FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y

# Utilities
RUN PCKGS=("curl" "vim" "openssl" "git" "htop" "nload" "mytop" "nethogs" "zip" "unzip" "sendmail" "sendmail-bin" "libcurl3-openssl-dev" "psmisc" "build-essential" "zlib1g-dev" "libpcre3" "libpcre3-dev" "memcached" "fail2ban" "iptables-persistent" "software-properties-common")
RUN for PCKG in "${PCKGS[@]}" \
    do \
	    apt-get -y install ${PCKG} \
    done

# Apache
RUN PCKGS=("apache2" "apache2-doc" "apachetop" "libapache2-mod-php" "libapache2-mod-fcgid" "apache2-suexec-pristine" "libapache2-mod-security2")
RUN for PCKG in "${PCKGS[@]}" \
    do \
	    apt-get -y install ${PCKG} \
    done

# PHP
RUN PCKGS=("mcrypt" "imagemagick" "php7.2" "php7.2-common" "php7.2-gd" "php7.2-imap" "php7.2-mysql" "php7.2-mysqli" "php7.2-cli" "php7.2-cgi" "php7.2-zip" "php-pear" "php-imagick" "php7.2-curl" "php7.2-mbstring" "php7.2-bcmath" "php7.2-xml" "php7.2-soap" "php7.2-opcache" "php7.2-intl" "php-apcu" "php-mail" "php-mail-mime" "php-all-dev" "php7.2-dev" "libapache2-mod-php7.2" "php7.2-memcached" "php-auth" "php-mcrypt" "composer")
RUN for PCKG in "${PCKGS[@]}" \
    do \
	    apt-get -y install ${PCKG} \
    done

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - && \
    apt-get -y install nodejs

# www-data user
RUN mkdir /var/www && \
    chown -R www-data:www-data /var/www && \
    chsh -s /bin/bash www-data

# Apache configuration
RUN a2enmod expires headers rewrite ssl suphp mpm_prefork security2

COPY ../apache/apache2config .
COPY ../apache/deflateconfig .
COPY ../apache/mimeconfig .
COPY ../apache/dir.conf /etc/apache2/mods-available/dir.conf
COPY ../apache/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf
COPY ../apache/configuration.sh .

RUN ./configuration.sh

RUN mkdir -p /srv/www/public_html && \
    mkdir -p /srv/www/logs && \
    mkdir -p /srv/www/ssl && \
    chown -R www-data:www-data /srv/www

RUN service apache2 reload

# PHP configuration
RUN sed -i 's/output_buffering = 4096/output_buffering = Off/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/max_execution_time = 30/max_execution_time = 60/' /etc/php/7.2/apache2/php.ini && \
	sed -i 's/; max_input_vars = 1000/max_input_vars = 5000/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/memory_limit = 128M/memory_limit = 256M/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/error_reporting = E_ALL \& \~E_DEPRECATED \& \~E_STRICT/error_reporting = E_ALL \& \~E_NOTICE \& \~E_STRICT \& \~E_DEPRECATED/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/post_max_size = 8M/post_max_size = 20M/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/' /etc/php/7.2/apache2/php.ini && \
    sed -i 's/Require all denied/Require all granted/g' /etc/apache2/mods-available/php7.2.conf

# ports for container to listen
EXPOSE 80
EXPOSE 443

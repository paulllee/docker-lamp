# base image of ubuntu version 18.04 
FROM ubuntu:18.04
LABEL author="Paul Lee"
LABEL company="Lyquix"

# setting the current working directory
WORKDIR /installation

# disables any interactive installation prompts
ENV DEBIAN_FRONTEND='noninteractive'

# Utilities installation
# optional pckgs: vim openssl htop nload mytop nethogs sendmail sendmail-bin libcurl3-openssl-dev psmisc build-essential iptables-persistent software-properties-common
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl git zip unzip libcurl3-openssl-dev zlib1g-dev libpcre3 libpcre3-dev memcached

# Apache installation
# optional pckgs: apache2-doc apachetop
RUN apt-get install -y apache2 libapache2-mod-php libapache2-mod-fcgid apache2-suexec-pristine libapache2-mod-security2

# PHP installation
# pckgs that broke: php-auth php-mcrypt
RUN apt-get install -y mcrypt imagemagick php7.2 php7.2-common php7.2-gd php7.2-imap php7.2-mysql php7.2-mysqli php7.2-cli php7.2-cgi php7.2-zip php-pear php-imagick \
    php7.2-curl php7.2-mbstring php7.2-bcmath php7.2-xml php7.2-soap php7.2-opcache php7.2-intl php-apcu php-mail php-mail-mime php-all-dev php7.2-dev libapache2-mod-php7.2 \
    php7.2-memcached composer 

# NodeJS installation
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs

# ModPagespeed installation
RUN curl -O https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
    dpkg -i mod-pagespeed*.deb && \
    rm mod-pagespeed*.deb && \
    apt-get -f install

# Apache configuration
# copying all the necessary files for configuration
COPY ./apache/installation /installation

COPY ./apache/conf/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./apache/conf/dir.conf /etc/apache2/mods-available/dir.conf
COPY ./apache/conf/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf

# www-data user
RUN mkdir /var/www; \
    chown -R www-data:www-data /var/www; \
    chsh -s /bin/bash www-data

# creating srv/www directory
RUN mkdir -p /srv/www/public_html; \
    mkdir -p /srv/www/logs; \
    mkdir -p /srv/www/ssl; \
    chown -R www-data:www-data /srv/www

# enabling modules
RUN a2enmod expires; \    
    a2enmod headers; \ 
    a2enmod rewrite; \ 
    a2enmod ssl; \ 
    a2enmod suphp; \  
    a2enmod mpm_prefork; \ 
    a2enmod security2

# setting permissions for script
RUN chmod 755 apache-configuration.sh
RUN bash apache-configuration.sh

RUN service apache2 restart

# PHP configuration
# copying all the necessary files for configuration
COPY ./php/php72-configuration.sh /installation/php72-configuration.sh

# setting permissions for script
RUN chmod 755 php72-configuration.sh
RUN bash php72-configuration.sh

# ports for container to listen
EXPOSE 80

# copying run bash script
WORKDIR /
COPY ./ubuntu1804/run.sh .
RUN chmod 755 run.sh

ENTRYPOINT [ "/run.sh" ]

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
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get -y install nodejs

# www-data user
RUN mkdir /var/www
RUN chown -R www-data:www-data /var/www
RUN chsh -s /bin/bash www-data

# Apache configuration
RUN a2enmod expires headers rewrite ssl suphp mpm_prefork security2


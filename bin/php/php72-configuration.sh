#!/bin/bash

# Author: Paul Lee
# Company: Lyquix

# editing the config files
sed -i 's/output_buffering =.*/output_buffering = Off/' /etc/php/7.2/apache2/php.ini
sed -i 's/max_execution_time =.*/max_execution_time = 60/' /etc/php/7.2/apache2/php.ini
sed -i 's/; max_input_vars =.*/max_input_vars = 5000/' /etc/php/7.2/apache2/php.ini
sed -i 's/memory_limit =.*/memory_limit = 256M/' /etc/php/7.2/apache2/php.ini
sed -i 's/error_reporting =.*/error_reporting = E_ALL \& \~E_NOTICE \& \~E_STRICT \& \~E_DEPRECATED/' /etc/php/7.2/apache2/php.ini
sed -i 's/post_max_size =.*/post_max_size = 20M/' /etc/php/7.2/apache2/php.ini
sed -i 's/upload_max_filesize =.*/upload_max_filesize = 20M/' /etc/php/7.2/apache2/php.ini

sed -i 's/Require all denied/Require all granted/g' /etc/apache2/mods-available/php7.2.conf

#!/bin/bash

# Author: Paul Lee
# Company: Lyquix

# editing the config files
sed -i 's/Timeout.*/Timeout 60/' /etc/apache2/apache2.conf
sed -i 's/MaxKeepAliveRequests.*/MaxKeepAliveRequests 0/' /etc/apache2/apache2.conf
sed -i '/<Directory \/srv\/>/{
n
n
n
n
n
r apache2config
}' /etc/apache2/apache2.conf

sed -i '/AddOutputFilterByType DEFLATE application\/xml/r deflateconfig' /etc/apache2/mods-available/deflate.conf

sed -i '/AddType application\/x-gzip .tgz/r mimeconfig' /etc/apache2/mods-available/mime.conf

sed -i '$r logrotateconfig' /etc/logrotate.d/apache2

sed -i 's/ModPagespeed on/ModPagespeed off/' /etc/apache2/mods-available/pagespeed.conf

# removing temp files
rm *config

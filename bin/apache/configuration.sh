#!/bin/bash

# Author: Paul Lee
# Company: Lyquix

sed -i 's/Timeout 300/Timeout 60/' /etc/apache2/apache2.conf
sed -i 's/MaxKeepAliveRequests 100/MaxKeepAliveRequests 0/' /etc/apache2/apache2.conf
sed -i '/<Directory \/srv\/>/{
n
n
n
n
n
r apache2config
}' /etc/apache2/apache2.conf
#!/bin/bash

# Author: Paul Lee
# Company: Lyquix

if [ $EUID != 0 ]
then
	echo "Please run this script as root, for example:"
	echo "sudo bash setup.sh"
	exit
fi

# updating and upgrading packages
apt-get update -y && apt-get upgrade -y

# creating the var/www directory and setting www-data
if [ -d /var/www ]
then
	echo "Directory already exists"
else
	mkdir /var/www
fi

chown -R www-data:www-data /var/www
chsh -s /bin/bash www-data

mkdir /home/ubuntu/docker-lamp

chown -R ubuntu:ubuntu /home/ubuntu/docker-lamp

echo 'Finished script!'

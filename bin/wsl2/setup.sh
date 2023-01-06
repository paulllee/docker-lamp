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

# making sure zip, unzip, and sed are installed
apt-get install -y zip unzip sed

# installing nodejs for dev
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

# creating the var/www directory and setting www-data
if [ -d /var/www ]
then
	echo "Directory already exists"
else
	mkdir /var/www
fi

chown -R www-data:www-data /var/www
chsh -s /bin/bash www-data

#creating the docker-lamp directory
mkdir /home/ubuntu/docker-lamp

chown -R ubuntu:ubuntu /home/ubuntu/docker-lamp

apt-get autoremove -y

echo 'Finished script!'
echo 'Continue the steps in the README.'

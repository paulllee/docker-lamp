#!/bin/bash

# Author: Paul Lee
# Company: Lyquix

if [ $EUID != 0 ]
then
	echo "Please run this script as root, for example:"
	echo "sudo bash wedsite-setup.sh"
	exit
fi

# asking user for website info
# all info gathered from the user is ran through a while loop to check that the credentials are correct
USER_VERIFIED=NO
while [ "$USER_VERIFIED" != 'YES' ]
do
    echo ''
    echo 'Enter the production website domain NAME (ex: lyquix):'
    read WEBSITE_DOMAIN_NAME

    echo ''
    echo 'Which version of Ubuntu does this website use? 1804, 2004, or 2204 (match sensitive):'
    read UBUNTU_VERSION

	echo ''
    echo "Does $WEBSITE_DOMAIN_NAME use a Content Management System (CMS)? YES or NO (case sensitive):"
    read HAS_DATABASE
    if [ "$HAS_DATABASE" == '' ]
    then
        HAS_DATABASE=NULL
    fi

    echo ''
    echo "WEBSITE DOMAIN NAME=$WEBSITE_DOMAIN_NAME"
	echo "UBUNTU VERSION=$UBUNTU_VERSION"
	echo "HAS DATABASE=$HAS_DATABASE"
    echo 'Are the the credentials above correct? YES or NO (case sensitive):'
    read USER_VERIFIED
    if [ "$USER_VERIFIED" == '' ]
    then
        USER_VERIFIED=NO
    fi
done

# setting the mysql version. 1804 is the last to come with 5.7 as default
if [ "$UBUNTU_VERSION" != "1804" ]
then
	MYSQL_VERSION=8
else
	MYSQL_VERSION=57
fi

# download latest release of docker-lamp
WORK_DIR="/home/ubuntu/docker-lamp/$WEBSITE_DOMAIN_NAME"

cd /home/ubuntu/docker-lamp/
curl -L https://github.com/paulllee/docker-lamp/archive/main.zip -o release.zip && unzip -d $WORK_DIR release.zip
rm /home/ubuntu/docker-lamp/release.zip
mv $WORK_DIR/docker-lamp-main/{.,}* $WORK_DIR
rmdir $WORK_DIR/docker-lamp-main
chown -R ubuntu:ubuntu $WORK_DIR

# change domain name, ubuntu version, and mysql version in env keys
sed -i "s/DOMAIN_NAME=lyquix/DOMAIN_NAME=$WEBSITE_DOMAIN_NAME/" $WORK_DIR/.env
sed -i "s/UBUNTU_VERSION=1804/UBUNTU_VERSION=$UBUNTU_VERSION/" $WORK_DIR/.env
sed -i "s/MYSQL_VERSION=57/MYSQL_VERSION=$MYSQL_VERSION/" $WORK_DIR/.env

if [ "$HAS_DATABASE" == 'YES' ]
then
    CMS_TYPE=NULL
    while [ "$CMS_TYPE" != 'JOOMLA' ] && [ "$CMS_TYPE" != 'WORDPRESS' ]
    do
        echo ''
        echo "Does $WEBSITE_DOMAIN_NAME use JOOMLA or WORDPRESS (case sensitive)?:"
        read CMS_TYPE
        if [ "$CMS_TYPE" == '' ]
        then
            CMS_TYPE=NULL
        fi

		echo ''
		echo "CMS TYPE=$CMS_TYPE"
		echo 'Are the the credentials above correct? YES or NO (case sensitive):'
		read USER_VERIFIED
		if [ "$USER_VERIFIED" == '' ]
		then
			USER_VERIFIED=NO
		fi
    done

    # asking for MySQL credentials
    USER_VERIFIED=NO
    while [ "$USER_VERIFIED" != 'YES' ]
    do
        echo ''
        echo "Type in the MySQL database password for $WEBSITE_DOMAIN_NAME:"
        read DATABASE_ROOT_PASS

        echo ''
        echo "Type in the MySQL database name for $WEBSITE_DOMAIN_NAME:"
        read DATABASE_NAME

        echo ''
        echo "Type in the MySQL database username for $WEBSITE_DOMAIN_NAME:"
        read DATABASE_USER

        echo ''
        echo "Type in the MySQL database password for $WEBSITE_DOMAIN_NAME:"
        read DATABASE_PASS

        echo ''
		echo "DATABASE ROOT PASSWORD=$DATABASE_ROOT_PASS"
        echo "DATABASE NAME=$DATABASE_NAME"
        echo "DATABASE USERNAME=$DATABASE_USER"
        echo "DATABASE PASSWORD=$DATABASE_PASS"
        echo 'Are the credentials above correct? YES or NO (case sensitive):'
        read USER_VERIFIED
        if [ "$USER_VERIFIED" == '' ]
        then
            USER_VERIFIED=NO
        fi
    done

	# change mysql credentials in env keys
	sed -i "s/'root_password_is_kept_in_single_quotes'/'$DATABASE_ROOT_PASS'/" $WORK_DIR/.env
	sed -i "s/database_name/$DATABASE_NAME/" $WORK_DIR/.env
	sed -i "s/user_name/$DATABASE_USER/" $WORK_DIR/.env
	sed -i "s/'database_password_is_kept_in_single_quotes'/'$DATABASE_PASS'/" $WORK_DIR/.env
fi
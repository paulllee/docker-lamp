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
    echo 'Enter the development website subdomain NAME including the period if none, NA (ex: dev.):'
    read WEBSITE_SUBDOMAIN_NAME

    echo ''
    echo 'Enter the production website domain EXTENSION including the period (ex: .com):'
    read WEBSITE_DOMAIN_EXTENSION

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
	echo "DEVELOPMENT WEBSITE SUBDOMAIN NAME=$WEBSITE_SUBDOMAIN_NAME"
    echo "WEBSITE DOMAIN EXTENSION=$WEBSITE_DOMAIN_EXTENSION"
	echo "UBUNTU VERSION=$UBUNTU_VERSION"
	echo "HAS DATABASE=$HAS_DATABASE"
    echo 'Are the the credentials above correct? YES or NO (case sensitive):'
    read USER_VERIFIED
    if [ "$USER_VERIFIED" == '' ]
    then
        USER_VERIFIED=NO
    fi
done

WEBSITE_ADDRESS=$WEBSITE_DOMAIN_NAME$WEBSITE_DOMAIN_EXTENSION

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

# SourceTree to clone repo
echo ''
echo "Next: open up SourceTree and clone the $WEBSITE_DOMAIN_NAME repo (development branch) into the \\\\wsl\$\\Ubuntu\\home\\ubuntu\\docker-lamp\\$WEBSITE_DOMAIN_NAME\\data\\www\\public_html directory"
echo ''
echo 'When you are done press Enter'
read USER_CHECKPOINT

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
        echo "Type in the MySQL database root password for $WEBSITE_DOMAIN_NAME:"
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

	# SSH for MySQL dump
    echo ''
    echo 'Open up PuTTY or Windows Terminal and SSH as root on the client side (check passwork for credentials)'
    echo 'If you use Windows Terminal, here is how to SSH in:'
    echo ''
    echo "ssh root@$WEBSITE_ADDRESS"
    echo 'Enter password: (check PassWork)'
    echo "cd /srv/www/$WEBSITE_SUBDOMAIN_NAME$WEBSITE_ADDRESS/"
    echo "mysqldump -u $DATABASE_USER -p $DATABASE_NAME > name.sql"
    echo ''
    echo 'In some circumstances, you will need to use the --no-tablespaces flag:'
    echo "mysqldump -u $DATABASE_USER -p $DATABASE_NAME > name.sql --no-tablespaces"
    echo ''
    echo 'In some circumstances, you will need to be logged in as root user for MySQL:'
    echo "mysqldump -u root -p $DATABASE_NAME > name.sql --no-tablespaces" 
    echo ''
    echo 'When you are done press Enter'
    read USER_CHECKPOINT

    # FTP using FileZilla to retrieve necessary files
	echo ''
    echo "FTP (using FileZilla) into the server as www-data user: download the sql file and put into the \\\\wsl\$\\Ubuntu\\home\\ubuntu\\docker-lamp\\$WEBSITE_DOMAIN_NAME\\data\\mysql-dump directory"
    echo "You can use the .gitignore file and download all the files that are ignored to the \\\\wsl\$\\Ubuntu\\home\\ubuntu\\docker-lamp\\$WEBSITE_DOMAIN_NAME\\data\\www\\public_html directory"
    echo ''
    echo "Make sure to have at least the .htaccess, wp-config.php (WordPress), and configuration.php (Joomla)"
    echo 'Look through the .htaccess and modify/remove the values to work for your local if needed (ex: check for redirecting and forcing ssl, password protection, ModPageSpeed must be turned Off)'
    echo "You do NOT have to edit wp-config.php (WordPress) or configuration.php (Joomla), they will be automatically updated later in the script!"
    echo ''
    echo 'When you are done press Enter'
    read USER_CHECKPOINT

    echo ''
    echo "Press Enter if you confirm that sql file is in the \\\\wsl\$\\Ubuntu\\home\\ubuntu\\docker-lamp\\$WEBSITE_DOMAIN_NAME\\data\\mysql-dump directory"
    read USER_CHECKPOINT

	# updating necessary values and srdb for WORDPRESS websites
    cd $WORK_DIR/data/www/public_html

    if [ "$CMS_TYPE" == 'WORDPRESS' ]
    then
		# docker container uses mysql as hostname
		sed -i 's/localhost/mysql/' wp-config.php

    elif [ "$CMS_TYPE" == 'JOOMLA' ]
    then
		# docker container uses mysql as hostname
        sed -i "s/host = 'localhost'/host = 'mysql'/" configuration.php

        # replacing all dev. addresses to test addresses
        sed -i "s/$WEBSITE_SUBDOMAIN_NAME$WEBSITE_ADDRESS/localhost/g" configuration.php
        # disabling ssl
        sed -i "s/force_ssl = '1'/force_ssl = '0'/" configuration.php
        sed -i "s/force_ssl = '2'/force_ssl = '0'/" configuration.php
        # cookie domain to test address
        sed -i "s/cookie_domain = '$WEBSITE_SUBDOMAIN_NAME$WEBSITE_ADDRESS'/cookie_domain = 'localhost'/" configuration.php
    fi

    JS_PATH="$(find $WORK_DIR/data/www/public_html -name 'js.php')"
    
    if grep -q "\$curl" "$JS_PATH"
    then
        echo ''
        echo 'The Lyquix template has the js.php curl fix'
    else
        curl https://raw.githubusercontent.com/paulllee/docker-lamp/main/bin/wsl2/jsphp-fix -o jsphp-fix

        sed -i '/ Remote script: /r jsphp-fix' $JS_PATH
        sed -i '/curl_close($curl);/{
            n
            d
            }' $JS_PATH

        rm jsphp-fix

        echo ''
        echo 'The Lyquix template has been updated with the js.php curl fix'
        echo 'Do not discard the changes of this file in SourceTree'
        echo 'You have to keep the changes in the js.php file'
    fi

    CSS_PATH="$(find $WORK_DIR/data/www/public_html -name 'css.php')"
    
    if grep -q "\$curl" "$CSS_PATH"
    then
        echo ''
        echo 'The Lyquix template has the css.php curl fix'
    else
        curl https://raw.githubusercontent.com/paulllee/docker-lamp/main/bin/wsl2/cssphp-fix -o cssphp-fix

        sed -i '/ Remote stylesheet: /r cssphp-fix' $CSS_PATH
        sed -i '/curl_close($curl);/{
            n
            d
            }' $CSS_PATH

        rm cssphp-fix

        echo ''
        echo 'The Lyquix template has been updated with the css.php curl fix'
        echo 'Do not discard the changes of this file in SourceTree'
        echo 'You have to keep the changes in the css.php file'
    fi
else
    # FTP using FileZilla to retrieve necessary files for non-cms websites
    echo "FTP (using FileZilla) into the server as www-data user: use the .gitignore file and download all the files that are ignored to the \\\\wsl\$\\Ubuntu\\home\\ubuntu\\docker-lamp\\$WEBSITE_DOMAIN_NAME\\data\\www\\public_html directory" 
    echo 'Look through the .htaccess and modify/remove the values to work for your local if needed (ex: check for redirecting and forcing ssl, password protection, ModPageSpeed must be turned Off)'
    echo ''
    echo 'When you are done press Enter'
    read USER_CHECKPOINT
fi

echo ''
echo "The full website setup of $WEBSITE_DOMAIN_NAME is now complete!"
echo "Go to the README for the final instructions."

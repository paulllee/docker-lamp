#!/bin/bash

# Author: Paul Lee
# Company: Lyquix

chown www-data:www-data /srv/www/public_html

apachectl -D FOREGROUND

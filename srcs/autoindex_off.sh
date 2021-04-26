#!/bin/bash

cp /var/www/tcinthia/autoindex/nginx_autoindex_off.conf /etc/nginx/sites-available/tcinthia
service nginx restart
echo "autoindex off"

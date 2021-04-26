#!/bin/bash

cp /var/www/tcinthia/autoindex/nginx.conf /etc/nginx/sites-available/tcinthia
service nginx restart
echo "autoindex on"

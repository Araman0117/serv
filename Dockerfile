# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tcinthia <tcinthia@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/26 15:52:56 by tcinthia          #+#    #+#              #
#    Updated: 2021/04/26 15:54:33 by tcinthia         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster

WORKDIR /

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install vim nginx mariadb-server php-fpm php-mysql php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip wget

RUN mkdir var/www/tcinthia

RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xzvf latest.tar.gz
RUN mv wordpress/ /var/www/tcinthia/wordpress
COPY srcs/wp-config.php /var/www/tcinthia/wordpress
RUN chown -R www-data:www-data /var/www/tcinthia/wordpress
RUN find /var/www/tcinthia/wordpress/ -type d -exec chmod 775 {} +
RUN find /var/www/tcinthia/wordpress/ -type f -exec chmod 664 {} +
RUN chmod 660 /var/www/tcinthia/wordpress/wp-config.php

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-english.tar.gz
RUN tar -xzvf phpMyAdmin-5.0.2-english.tar.gz
RUN mv phpMyAdmin-5.0.2-english/ /var/www/tcinthia/phpmyadmin
COPY /srcs/config.inc.php /var/www/tcinthia/phpmyadmin

COPY ./srcs/nginx.conf /etc/nginx/sites-available/tcinthia
RUN ln -s /etc/nginx/sites-available/tcinthia /etc/nginx/sites-enabled/
RUN mkdir /var/www/tcinthia/autoindex
COPY ./srcs/nginx.conf /var/www/tcinthia/autoindex
COPY ./srcs/nginx_autoindex_off.conf /var/www/tcinthia/autoindex
COPY ./srcs/autoindex_on.sh .
COPY ./srcs/autoindex_off.sh .
COPY ./srcs/start_script.sh .

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-subj "/C=ru/ST=Moscow/L=Moscow/O=no/OU=no/CN=tcinthia/" \
	-keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt

RUN service mysql start \
	&& mysql -u root \
	&& mysql --execute="CREATE DATABASE wp_base; \
						GRANT ALL PRIVILEGES ON wp_base.* TO 'root'@'localhost'; \
						FLUSH PRIVILEGES; \
						UPDATE mysql.user SET plugin = 'mysql_native_password' WHERE user='root';"

EXPOSE 80 443

CMD bash start_script.sh

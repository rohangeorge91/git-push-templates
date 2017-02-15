FROM php:7.0-apache

#Listen to 8080
ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf

#Expose Port 8080
ADD ports.conf /etc/apache2/ports.conf

COPY . /var/www/html/
EXPOSE 8080

FROM php:7.0-apache

ADD apache-config.conf /etc/apache2/sites-enabled/000-default.conf
ADD ports.conf /etc/apache2/ports.conf
COPY . /var/www/html/
EXPOSE 8080

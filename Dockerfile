FROM php:8.1-cli

ARG BUILD

# install composer
RUN apt-get update && \
    apt-get install -y git zip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN chmod 755 /usr/bin/composer

# system setup
WORKDIR /usr/lib/small-maker

# run tests
COPY . /usr/lib/small-maker

RUN COMPOSER_ALLOW_SUPERUSER=1 composer update
RUN echo "$BUILD"
RUN bash -c 'if [ "$BUILD" == "1" ]; then ./vendor/bin/phpunit --testdox tests; fi'

ENTRYPOINT bash -c 'if [ "$BUILD" == "0" ]; then sleep infinity; fi'

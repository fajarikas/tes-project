FROM php:8.1-cli-alpine

# environtmen variable
ENV \
    APP_DIR="/app" \
    APP_PORT="8001"

COPY . $APP_DIR
COPY .env $APP_DIR/.env

RUN docker-php-ext-install mysqli pdo pdo_mysql
RUN apk add --update \
    curl \
    php \
    php-opcache \
    php-openssl \
    php-pdo \
    # php-mysql \
    php-json \
    php-phar \
    php-dom \
    && rm -rf /var/cache/apk*


RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/bin --filename=composer

RUN cd $APP_DIR && composer update
RUN cd $APP_DIR && php artisan key:generate

WORKDIR $APP_DIR

CMD php artisan serve --host=0.0.0.0 --port=$APP_PORT

EXPOSE $APP_PORT

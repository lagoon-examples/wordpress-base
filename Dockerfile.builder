FROM amazeeio/php:7.1-cli

COPY composer.json composer.lock /app/
RUN composer install --no-dev

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp

RUN docker-php-ext-install pdo_mysql pdo mysqli
RUN docker-php-ext-install pdo_mysql pdo mysqli

COPY . /app

ENV WEBROOT=web

ARG CLI_IMAGE
FROM ${CLI_IMAGE:-builder} as builder

FROM amazeeio/php:7.1-fpm

RUN docker-php-ext-install pdo_mysql pdo mysqli
RUN docker-php-ext-install pdo_mysql pdo mysqli
COPY --from=builder /app /app

ARG CLI_IMAGE
FROM ${CLI_IMAGE:-builder} AS builder

FROM uselagoon/php-8.3-fpm:latest

COPY --from=builder /app /app

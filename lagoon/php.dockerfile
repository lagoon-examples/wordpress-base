ARG CLI_IMAGE
FROM ${CLI_IMAGE:-builder} as builder

FROM uselagoon/php-8.0-fpm:latest

COPY --from=builder /app /app

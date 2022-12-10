ARG CLI_IMAGE
FROM ${CLI_IMAGE:-builder} as builder

FROM uselagoon/php-8.1-fpm:latest

COPY --from=builder /app /app

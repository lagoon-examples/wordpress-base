ARG CLI_IMAGE
FROM ${CLI_IMAGE:-builder} as builder

FROM uselagoon/php-7.4-fpm:latest

COPY --from=builder /app /app

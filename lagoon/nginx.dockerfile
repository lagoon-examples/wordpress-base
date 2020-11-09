ARG CLI_IMAGE
FROM ${CLI_IMAGE:-builder} as builder

FROM uselagoon/nginx:latest
COPY lagoon/nginx/nginx.conf /etc/nginx/conf.d/app.conf

# Adding Stagefile helper
COPY lagoon/nginx/stagefile-*.conf /etc/nginx/conf.d/wordpress/

COPY --from=builder /app /app

ENV WEBROOT=web

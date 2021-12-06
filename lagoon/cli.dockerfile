FROM uselagoon/php-8.0-cli:latest

COPY composer.* /app/
RUN composer self-update --2 \
  && composer install --no-dev --prefer-dist

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp && chmod +x /usr/local/bin/wp

# Add function to .bashrc to run wp-cli with --allow-root
RUN echo 'wp() { /usr/local/bin/wp "$@" --allow-root; }' >>  ~/.bashrc \
    && mkdir -p ~/.wp-cli \
    && echo "path: '/app/web/wp'" > ~/.wp-cli/config.yml

COPY . /app

ENV WEBROOT=web
ENV PAGER=less

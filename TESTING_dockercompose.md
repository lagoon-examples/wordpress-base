Docker Compose Wordpress base - php8, nginx, mariadb
====================================================

This is a docker-compose version of the Lando example tests:

Start up tests
--------------

Run the following commands to get up and running with this example.

```bash
# Should remove any previous runs and poweroff
sed -i -e "/###/d" docker-compose.yml
docker network inspect amazeeio-network >/dev/null || docker network create amazeeio-network
docker compose down

# Should start up our Lagoon Wordpress site successfully
docker compose build && docker compose up -d

# Ensure mariadb pod is ready to connect
docker run --rm --net wordpress-base_default amazeeio/dockerize dockerize -wait tcp://mariadb:3306 -timeout 1m
```

Verification commands
---------------------

Run the following commands to validate things are rolling as they should.

```bash
# Should be able to site install via wp-cli
docker compose exec -T cli bash -c "composer install"
docker compose exec -T cli bash -c "wp core install --allow-root --url=wordpress-base.docker.amazee.io --title=\'Wordpress-site-install\' --admin_user=admin --admin_email=admin@example.com"
docker compose exec -T cli bash -c "wp theme activate twentytwentyfive"
docker compose exec -T cli bash -c "wp cache flush"
docker compose exec -T cli bash -c "wp core verify-checksums" | grep "Success"

# Should have all the services we expect
docker ps --filter label=com.docker.compose.project=wordpress-base | grep Up | grep wordpress-base-nginx-1
docker ps --filter label=com.docker.compose.project=wordpress-base | grep Up | grep wordpress-base-mariadb-1
docker ps --filter label=com.docker.compose.project=wordpress-base | grep Up | grep wordpress-base-php-1
docker ps --filter label=com.docker.compose.project=wordpress-base | grep Up | grep wordpress-base-cli-1

# Should ssh against the cli container by default
docker compose exec -T cli bash -c "env | grep LAGOON=" | grep cli

# Should have the correct environment set
docker compose exec -T cli bash -c "env" | grep LAGOON_ROUTE | grep wordpress-base.docker.amazee.io
docker compose exec -T cli bash -c "env" | grep LAGOON_ENVIRONMENT_TYPE | grep development

# Should be running PHP 8
docker compose exec -T cli bash -c "php -v" | grep "PHP 8."

# Should have composer
docker compose exec -T cli bash -c "composer --version"

# Should have php cli
docker compose exec -T cli bash -c "php --version"

# Should have wp-cli
docker compose exec -T cli bash -c "wp --version"

# Should have npm
docker compose exec -T cli bash -c "npm --version"

# Should have node
docker compose exec -T cli bash -c "node --version"

# Should have yarn
docker compose exec -T cli bash -c "yarn --version"

# Ensure that Wordpress doesn't redirect the curl request to 8080
# remove_filter('template_redirect', 'redirect_canonical');
docker compose exec -T php sh -c "echo PD9waHAgcmVtb3ZlX2ZpbHRlcigndGVtcGxhdGVfcmVkaXJlY3QnLCAncmVkaXJlY3RfY2Fub25pY2FsJyk7 | base64 -d > /app/web/content/themes/twentytwentyfive/functions.php"

# Should have a running Wordpress site served by nginx on port 8080
docker compose exec -T cli bash -c "curl -kL http://nginx:8080" | grep "Wordpress-site-install"
# docker compose port nginx 8080 | xargs curl -kL | grep "Wordpress-site-install"

# Should be serving content through Varnish
docker compose exec -T cli bash -c "curl -kL http://varnish:8080" | grep "Wordpress-site-install"
docker compose exec -T cli bash -c "curl -I http://varnish:8080" | grep "Varnish/"
docker compose exec -T varnish sh -c "varnishlog -d" | grep "User-Agent" | grep "curl"

# Should be able to db-export and db-import the database
docker compose exec -T cli bash -c "wp db --defaults export /app/test.sql"
docker compose exec -T cli bash -c "wp db --defaults drop --yes"
docker compose exec -T cli bash -c "wp db --defaults create"
docker compose exec -T cli bash -c "wp db --defaults import /app/test.sql"
docker compose exec -T cli bash -c "rm /app/test.sql*"

# Should still have a running Wordpress site served by nginx on port 8080
docker compose exec -T cli bash -c "curl -kL http://nginx:8080" | grep "Wordpress-site-install"
#docker compose port nginx 8080 | xargs curl -kL | grep "Wordpress-site-install"

# Should be able to show the wordpress tables
docker compose exec -T cli bash -c "echo U0hPVyBUQUJMRVM7 | base64 -d > /app/showtables.sql"
docker compose exec -T cli bash -c "wp db --defaults query < /app/showtables.sql" | grep wp_users

# Should be able to rebuild and persist the database
docker compose build && docker compose up -d
docker compose exec -T cli bash -c "echo U0hPVyBUQUJMRVM7 | base64 -d > /app/showtables.sql"
docker compose exec -T cli bash -c "wp db --defaults query < /app/showtables.sql" | grep wp_users
```

Destroy tests
-------------

Run the following commands to trash this app like nothing ever happened.

```bash
# Should be able to destroy our Wordpress site with success
docker compose down --volumes --remove-orphans
```

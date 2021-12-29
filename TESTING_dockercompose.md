Docker Compose Wordpress simple - php8.0, nginx, mariadb
========================================================

This is a docker-compose version of the Lando example tests:

Start up tests
--------------

Run the following commands to get up and running with this example.

```bash
# Should remove any previous runs and poweroff
sed -i -e "/###/d" docker-compose.yml
docker network inspect amazeeio-network >/dev/null || docker network create amazeeio-network
docker-compose down

# Should start up our Lagoon Wordpress site successfully
docker-compose build && docker-compose up -d

# Ensure mariadb pod is ready to connect
docker run --rm --net wordpress-example-simple_default amazeeio/dockerize dockerize -wait tcp://mariadb:3306 -timeout 1m
```

Verification commands
---------------------

Run the following commands to validate things are rolling as they should.

```bash
# Should be able to site install via wp-cli
docker-compose exec -T cli bash -c "composer install"
docker-compose exec -T cli bash -c "wp core install --allow-root --url=wordpress-example-simple.docker.amazee.io --title=\'Wordpress-site-install\' --admin_user=admin --admin_email=admin@example.com"
docker-compose exec -T cli bash -c "wp cache flush"
docker-compose exec -T cli bash -c "HTTP_HOST=wordpress-example-simple.docker.amazee.io wp core verify-checksums" | grep "Success"

# Should have all the services we expect
docker ps --filter label=com.docker.compose.project=wordpress-example-simple | grep Up | grep wordpress-example-simple_nginx_1
docker ps --filter label=com.docker.compose.project=wordpress-example-simple | grep Up | grep wordpress-example-simple_mariadb_1
docker ps --filter label=com.docker.compose.project=wordpress-example-simple | grep Up | grep wordpress-example-simple_php_1
docker ps --filter label=com.docker.compose.project=wordpress-example-simple | grep Up | grep wordpress-example-simple_cli_1

# Should ssh against the cli container by default
docker-compose exec -T cli bash -c "env | grep LAGOON=" | grep cli

# Should have the correct environment set
docker-compose exec -T cli bash -c "env" | grep LAGOON_ROUTE | grep wordpress-example-simple.docker.amazee.io
docker-compose exec -T cli bash -c "env" | grep LAGOON_ENVIRONMENT_TYPE | grep development

# Should be running PHP 8
docker-compose exec -T cli bash -c "php -v" | grep "PHP 8."

# Should have composer
docker-compose exec -T cli bash -c "composer --version"

# Should have php cli
docker-compose exec -T cli bash -c "php --version"

# Should have wp-cli
docker-compose exec -T cli bash -c "wp --version"

# Should have npm
docker-compose exec -T cli bash -c "npm --version"

# Should have node
docker-compose exec -T cli bash -c "node --version"

# Should have yarn
docker-compose exec -T cli bash -c "yarn --version"

# Ensure that Wordpress doesn't redirect the curl request to 8080
# remove_filter('template_redirect', 'redirect_canonical');
#docker-compose exec -T php sh -c "sed -i \'1 aremove_filter(\'template_redirect\',\'redirect_canonical\');\' /app/web/content/themes/twentytwentyone/functions.php"
docker-compose exec -T php sh -c "echo cmVtb3ZlX2ZpbHRlcigndGVtcGxhdGVfcmVkaXJlY3QnLCAncmVkaXJlY3RfY2Fub25pY2FsJyk7 | base64 -d >> /app/web/content/themes/twentytwentyone/functions.php"

# Should have a running Wordpress site served by nginx on port 8080
docker-compose exec -T cli bash -c "curl -kL http://nginx:8080" | grep "Wordpress-site-install"
# docker-compose port nginx 8080 | xargs curl -kL | grep "Wordpress-site-install"

# Should be able to db-export and db-import the database
docker-compose exec -T cli bash -c "wp db export /app/test.sql"
docker-compose exec -T cli bash -c "wp db drop --yes"
docker-compose exec -T cli bash -c "wp db create"
docker-compose exec -T cli bash -c "wp db import /app/test.sql"
docker-compose exec -T cli bash -c "rm /app/test.sql*"

# Should still have a running Wordpress site served by nginx on port 8080
docker-compose exec -T cli bash -c "curl -kL http://nginx:8080" | grep "Wordpress-site-install"
#docker-compose port nginx 8080 | xargs curl -kL | grep "Wordpress-site-install"

# Should be able to show the wordpress tables
docker-compose exec -T cli bash -c "wp db query \'SHOW TABLES\'" | grep wp_users

# Should be able to rebuild and persist the database
docker-compose build && docker-compose up -d
docker-compose exec -T cli bash -c "wp db query \'SHOW TABLES\'" | grep wp_users
```

Destroy tests
-------------

Run the following commands to trash this app like nothing ever happened.

```bash
# Should be able to destroy our Wordpress site with success
docker-compose down --volumes --remove-orphans
```

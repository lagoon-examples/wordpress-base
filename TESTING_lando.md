Lando Wordpress simple - php8.0, nginx, mariadb
===============================================

This example exists primarily to test the following documentation:

* [Lagoon Recipe](https://docs.lando.dev/config/lagoon.html)

Start up tests
--------------

Run the following commands to get up and running with this example.

```bash
# Should remove any previous runs and poweroff
lando --clear
lando destroy -y
lando poweroff

# Should start up our Lagoon Drupal 9 site successfully
lando start
```

Verification commands
---------------------

Run the following commands to validate things are rolling as they should.

```bash
# Should be able to site install via wp-cli
lando composer install
lando wp core install --allow-root --url=wordpress-example.lndo.site --title=\'Wordpress-site-install\' --admin_user=admin --admin_email=admin@example.com
lando wp cache flush
lando wp core verify-checksums | grep "Success"

# Should have all the services we expect
docker ps --filter label=com.docker.compose.project=wordpressexamplesimple | grep Up | grep wordpressexamplesimple_nginx_1
docker ps --filter label=com.docker.compose.project=wordpressexamplesimple | grep Up | grep wordpressexamplesimple_mariadb_1
docker ps --filter label=com.docker.compose.project=wordpressexamplesimple | grep Up | grep wordpressexamplesimple_php_1
docker ps --filter label=com.docker.compose.project=wordpressexamplesimple | grep Up | grep wordpressexamplesimple_cli_1

# Should ssh against the cli container by default
lando ssh -c "env | grep LAGOON=" | grep cli

# Should have the correct environment set
lando ssh -c "env" | grep LAGOON_ROUTE | grep wordpress-example.lndo.site
lando ssh -c "env" | grep LAGOON_ENVIRONMENT_TYPE | grep development

# Should be running PHP 8
lando ssh -c "php -v" | grep "PHP 8"

# Should have composer
lando composer --version

# Should have php cli
lando php --version

# Should have drush
lando wp --version

# Should have npm
lando npm --version

# Should have node
lando node --version

# Should have yarn
lando yarn --version

# Should have lagoon cli
lando lagoon --version | grep lagoon

# Ensure that Wordpress doesn't redirect the curl request to 8080
# remove_filter('template_redirect', 'redirect_canonical');
#docker-compose exec -T php sh -c "sed -i \'1 aremove_filter(\'template_redirect\',\'redirect_canonical\');\' /app/web/content/themes/twentytwentyone/functions.php"
lando ssh -s php -c "echo cmVtb3ZlX2ZpbHRlcigndGVtcGxhdGVfcmVkaXJlY3QnLCAncmVkaXJlY3RfY2Fub25pY2FsJyk7 | base64 -d >> /app/web/content/themes/twentytwentyone/functions.php"

# Should have a running Wordpress site served by nginx on port 8080
lando ssh -c "curl -kL http://nginx:8080" | grep "Wordpress-site-install"
# docker-compose port nginx 8080 | xargs curl -kL | grep "Wordpress-site-install"

# Should be able to db-export and db-import the database
lando db-export test.sql
lando db-import test.sql.gz
rm test.sql*

# Should still have a running Wordpress site served by nginx on port 8080
lando ssh -c "curl -kL http://nginx:8080" | grep "Wordpress-site-install"
#docker-compose port nginx 8080 | xargs curl -kL | grep "Wordpress-site-install"

# Should be able to show the wordpress tables
lando wp db query "SHOW TABLES" | grep "wp_users"

# Should be able to rebuild and persist the database
lando rebuild -y
lando wp db query "SHOW TABLES" | grep "wp_users"
```

Destroy tests
-------------

Run the following commands to trash this app like nothing ever happened.

```bash
# Should be able to destroy our Wordpress site with success
lando destroy -y
lando poweroff
```

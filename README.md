# Wordpress and Lagoon

This repository is an example of how to use Lagoon and Wordpress. It uses our local development environment, Pygmy. For more information on Pygmy, [check out the documentation](https://pygmy.readthedocs.io/en/master/). If you've never set up a Lagoon site locally, you'll need to get Docker and Pygmy set up, [so read the documentation on that](https://lagoon.readthedocs.io/en/latest/using_lagoon/local_development_environments/), it's quick!

## Getting Started

1. Open up a command line prompt. 
2. Clone the repo.
3. `cd` into the repo.
4. Run `composer install`.
5. Run `pygmy up`.
6. Run `docker-compose build`.
7. Run `docker-compose up -d`.
8. You should now have a fully functional Wordpress site at [`wordpress-nginx.docker.amazee.io`](http://wordpress-nginx.docker.amazee.io)!

## WordPress and Composer

This setup uses Composer with Wordpress. If you're looking for more information on using Composer and WordPress together, go check out http://composer.rarst.net.

*Note*: When installing plugins, do not install them through the UI. Either use Composer or the Wordpress CLI (included in this example). For more information on how to use the Wordpress CLI, [check out the documentation](https://wp-cli.org/).

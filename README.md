# WordPress and Lagoon

This repository is an example of how to use Lagoon and WordPress. It uses our local development environment, Pygmy. For more information on Pygmy, [check out the documentation](https://pygmy.readthedocs.io/en/master/). If you've never set up a Lagoon site locally, you'll need to get Docker and Pygmy set up, [so read the documentation on that](https://lagoon.readthedocs.io/en/latest/using_lagoon/local_development_environments/), it's quick!

## Getting Started

1. Open up a command line prompt.
2. Clone the repo.
3. `cd` into the repo.
4. Run `pygmy start`.
5. Run `docker-compose build`.
6. Run `docker-compose up -d`.
7. Run `docker-compose exec cli composer install` - this will make sure all of the dependencies have been added inside of the container.
8. You should now have a fully functional local WordPress site at [`wordpress-nginx.docker.amazee.io`](http://wordpress-nginx.docker.amazee.io)!

## WordPress and Composer

This setup uses Composer with WordPress. If you're looking for more information on using Composer and WordPress together, go check out http://composer.rarst.net.

*Note*: When installing plugins, do not install them through the UI. Either use Composer or the WordPress CLI (included in this example). For more information on how to use the WordPress CLI, [check out the documentation](https://wp-cli.org/).

## What's Next

This example gives you a working *local* project using WordPress and Lagoon. For information about how to deploy your project using Lagoon, [check out our documentation](https://lagoon.readthedocs.io/en/latest/using_lagoon/setup_project/), [watch our deployment demo](https://www.youtube.com/watch?v=XiaH7gqUXWc_), or [chat with us](https://amazeeio.rocket.chat/home)!

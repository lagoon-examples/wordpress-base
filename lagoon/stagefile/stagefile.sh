#!/bin/sh

# If LAGOON_ENVIRONMENT_TYPE is set to development we add the stagefile rules
if [ "$LAGOON_ENVIRONMENT_TYPE" == "development" ]; then
    cp /etc/nginx/conf.d-available/wordpress/stagefile-*.conf /etc/nginx/conf.d/wordpress/  
fi

#!/bin/sh

# If LAGOON_ENVIRONMENT_TYPE is set to development we add the stagefile rules
if [ "$LAGOON_ENVIRONMENT_TYPE" == "development" ]; then
echo oi!
    cp /etc/nginx/conf.d-available/stagefile-*.conf /etc/nginx/conf.d/
fi

echo uih!
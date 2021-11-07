#!/bin/bash

echo "Creating email account: user@example.com/password ."
setup email add user@example.com password

echo "Creating email account: example-sender@example.com/password ."
setup email add example-sender@example.com password

echo "Start up mailserver"
/usr/bin/dumb-init -- supervisord -c /etc/supervisor/supervisord.conf


#!/bin/sh

if [ "$1" = "supervisord" ]; then
    exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
else
    exec "$@"
fi
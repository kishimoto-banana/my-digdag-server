#!/bin/bash
set -eu

case "$1" in
  serve)
    envsubst < /usr/app/digdag-server/server.properties > /usr/app/digdag-server/server.properties.env
    java -jar -Xms1g -Xmx1g \
        -XX:+AggressiveOpts \
        -XX:+UseConcMarkSweepGC \
        -XX:+CMSClassUnloadingEnabled \
        /usr/app/digdag-server/bin/digdag \
        server \
        -c /usr/app/digdag-server/server.properties.env
    ;;
  *)
    exec "$@"
    ;;
esac

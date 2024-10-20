#!/bin/sh

# This is a local Lua docs webserver with hot reload of website content.
# This is to be used for documentation writing.

docker compose -f docker-compose.yml -f docker-compose-run.yml up -d --build

IP=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $2}')
IP=$( cut -d $' ' -f 1 <<< $IP )

URL=$(docker ps --format="{{.Ports}}\t{{.Names}}" | grep lua-docs | sed -En "s|0.0.0.0:([0-9]+).*|http://$IP:\1|p")

echo ""
echo "----------------------"
echo "Open in browser: $URL"
echo "----------------------"
echo ""

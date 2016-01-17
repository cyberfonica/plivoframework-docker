#!/bin/bash

FS_INBOUND_ADDRESS="$(getent hosts freeswitch | awk '{print $1}'):8021"
REDIS_HOST="$(getent hosts redis | awk '{print $1}')"

HTTP_ADDRESS="0.0.0.0:8088"
HTTP_ADDRESS_CACHE="0.0.0.0:8089"
FS_OUTBOUND_ADDRESS="0.0.0.0:8084"

AUTH_ID_DEFAULT="plivo"
AUTH_TOKEN_DEFAULT="plivo"
REDIS_PASSWORD_DEFAULT=""

AUTH_ID=${AUTH_ID:=$AUTH_ID_DEFAULT}
AUTH_TOKEN=${AUTH_TOKEN:=$AUTH_TOKEN_DEFAULT}
REDIS_PASSWORD=${REDIS_PASSWORD:=$REDIS_PASSWORD_DEFAULT}

PLIVO_CONF=/usr/local/plivo/etc/plivo/default.conf
PLIVO_CACHE_CONF=/usr/local/plivo/etc/plivo/cache/cache.conf

echo "setting AUTH_ID to $AUTH_ID"
sed -e "s|^#\{0,1\}AUTH_ID = .*$|AUTH_ID = $AUTH_ID|g" -i $PLIVO_CONF
sed -e "s|^#\{0,1\}AUTH_ID = .*$|AUTH_ID = $AUTH_ID|g" -i $PLIVO_CACHE_CONF

echo "setting AUTH_TOKEN to $AUTH_TOKEN"
sed -e "s|^#\{0,1\}AUTH_TOKEN = .*$|AUTH_TOKEN = $AUTH_TOKEN|g" -i $PLIVO_CONF
sed -e "s|^#\{0,1\}AUTH_TOKEN = .*$|AUTH_TOKEN = $AUTH_TOKEN|g" -i $PLIVO_CACHE_CONF

echo "disabling ALLOWED_IPS"
sed -e "s|^#\{0,1\}ALLOWED_IPS = .*$|# ALLOWED_IPS = 127.0.0.1|g" -i $PLIVO_CONF
sed -e "s|^#\{0,1\}ALLOWED_IPS = .*$|# ALLOWED_IPS = 127.0.0.1|g" -i $PLIVO_CACHE_CONF

echo "setting HTTP_ADDRESS to $HTTP_ADDRESS"
sed -e "s|^#\{0,1\}HTTP_ADDRESS = .*$|HTTP_ADDRESS = $HTTP_ADDRESS|g" -i $PLIVO_CONF

echo "setting cache HTTP_ADDRESS to $HTTP_ADDRESS_CACHE"
sed -e "s|^#\{0,1\}HTTP_ADDRESS = .*$|HTTP_ADDRESS = $HTTP_ADDRESS_CACHE|g" -i $PLIVO_CACHE_CONF

echo "setting FS_INBOUND_ADDRESS to $FS_INBOUND_ADDRESS"
sed -e "s|^#\{0,1\}FS_INBOUND_ADDRESS = .*$|FS_INBOUND_ADDRESS = $FS_INBOUND_ADDRESS|g" -i $PLIVO_CONF

echo "setting FS_OUTBOUND_ADDRESS to $FS_OUTBOUND_ADDRESS"
sed -e "s|^#\{0,1\}FS_OUTBOUND_ADDRESS = .*$|FS_OUTBOUND_ADDRESS = $FS_OUTBOUND_ADDRESS|g" -i $PLIVO_CONF

echo "setting REDIS_HOST to $REDIS_HOST"
sed -e "s|^#\{0,1\}REDIS_HOST = .*$|REDIS_HOST = $REDIS_HOST|g" -i $PLIVO_CACHE_CONF

if [ ! -z "$REDIS_PASSWORD" ]; then
	echo "setting REDIS_PASSWORD to $REDIS_PASSWORD"
	sed -e "s|^#\{0,1\}REDIS_PASSWORD = .*$|REDIS_PASSWORD = $REDIS_PASSWORD|g" -i $PLIVO_CACHE_CONF
fi

exec "$@"

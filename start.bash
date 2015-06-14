#!/bin/bash

#
# start.bash
#

HAPROXY="/etc/haproxy"
PIDFILE="/var/run/haproxy.pid"

cd "$HAPROXY"

cp haproxy.cfg.in haproxy.cfg

BA=`echo $COUCHDB_USERNAME:$COUCHDB_PASSWORD|base64|sed s/Cg==//`

echo >> haproxy.cfg
echo "backend couchdbs" >> haproxy.cfg

IFS=","
index=1
for server in $COUCHDB_SERVERS; do
	echo "        server couchdb$index $server check inter 5s ssl verify none" >> haproxy.cfg
	index=$((index + 1))
done
echo "        http-request set-header Authorization Basic\ $BA" >> haproxy.cfg
if [[ -n $COUCHDB_HOSTNAME ]]; then
	echo "        http-request set-header Host $COUCHDB_HOSTNAME" >> haproxy.cfg
fi

exec haproxy -f "$HAPROXY/haproxy.cfg" -p "$PIDFILE"

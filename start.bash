#!/bin/bash

#
# start.bash
#

HAPROXY="/etc/haproxy"
PIDFILE="/var/run/haproxy.pid"

cd "$HAPROXY"

cp haproxy.cfg.in haproxy.cfg

echo >> haproxy.cfg
echo "backend couchdbs" >> haproxy.cfg

IFS=","
index=1
for server in $COUCHDB_SERVERS; do
	echo "        server couchdb$index $server check inter 5s ssl verify none" >> haproxy.cfg
	index=$((index + 1))
done

if [[ ! -z $COUCHDB_USERNAME ]] && [[ ! -z $COUCHDB_PASSWORD ]]; then
    BA=`python -c "import base64; print base64.urlsafe_b64encode(\"$COUCHDB_USERNAME:$COUCHDB_PASSWORD\")"`
    echo "        http-request set-header Authorization Basic\ $BA" >> haproxy.cfg
fi

if [[ -n $COUCHDB_HOSTNAME ]]; then
	echo "        http-request set-header Host $COUCHDB_HOSTNAME" >> haproxy.cfg
fi

exec haproxy -f "$HAPROXY/haproxy.cfg" -p "$PIDFILE"

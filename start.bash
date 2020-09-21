#!/bin/bash

#
# start.bash
#

HAPROXY="/etc/haproxy"
PIDFILE="/var/run/haproxy.pid"

cd "$HAPROXY"

echo "COUCHDB_BIND: ${COUCHDB_BIND:=*:5984}"
echo "COUCHDB_CHECK: ${COUCHDB_CHECK:=check inter 5s}"
echo "COUCHDB_BALANCE: ${COUCHDB_BALANCE:=uri depth 2}"
echo "MAXCONN: ${MAXCONN:=512}"

cat <<EOF > haproxy.cfg
global
        maxconn $MAXCONN
        spread-checks 5

defaults
        mode http
        log global
        monitor-uri /_haproxy_health_check
        option log-health-checks
        option httplog
        balance $COUCHDB_BALANCE
        option forwardfor
        option redispatch
        retries 4
        option http-server-close
        timeout client 150000
        timeout server 3600000
        timeout connect 500

        stats enable
        stats scope .
        stats uri /_stats

frontend http-in
        bind $COUCHDB_BIND
        default_backend couchdbs

backend couchdbs
        option httpchk GET /_up
        http-check disable-on-404
EOF

IFS=","
index=1
for server in $COUCHDB_SERVERS; do
	echo "        server couchdb$index $server $COUCHDB_CHECK" >> haproxy.cfg
	index=$((index + 1))
done

if [[ ! -z $COUCHDB_USERNAME ]] && [[ ! -z $COUCHDB_PASSWORD ]]; then
    BA=`python -c "import base64; print base64.urlsafe_b64encode(\"$COUCHDB_USERNAME:$COUCHDB_PASSWORD\")"`
    echo "        http-request set-header Authorization Basic\ $BA" >> haproxy.cfg
fi

if [[ -n $COUCHDB_HOSTNAME ]]; then
	echo "        http-request set-header Host $COUCHDB_HOSTNAME" >> haproxy.cfg
fi

echo ">>>>>>>>>> FILE START: $HAPROXY/haproxy.cfg"
cat "$HAPROXY/haproxy.cfg"
echo "<<<<<<<<<< FILE END:   $HAPROXY/haproxy.cfg"

exec haproxy -f "$HAPROXY/haproxy.cfg" -p "$PIDFILE"

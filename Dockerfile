#
# Haproxy Dockerfile
#
# https://github.com/dockerfile/haproxy
#

# Pull base image.
FROM ubuntu:14.04

# Install Haproxy.
RUN \
  sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y haproxy=1.5.3-1~ubuntu14.04.1 python && \
  sed -i 's/^ENABLED=.*/ENABLED=1/' /etc/default/haproxy && \
  rm -rf /var/lib/apt/lists/*

# Add files.
ADD haproxy.cfg.in /etc/haproxy/haproxy.cfg.in
ADD start.bash /haproxy-start

# Define working directory.
WORKDIR /etc/haproxy

# Allow to specify comma-separated list of COUCHDB_SERVERS from ENV
ENV COUCHDB_SERVERS="localhost:5984"

# Credentials
ENV COUCHDB_USERNAME=""
ENV COUCHDB_PASSWORD=""

# For proxy to work, it's sometime necessary to set the hostname right
ENV COUCHDB_HOSTNAME=""

# Define default command.
CMD ["bash", "/haproxy-start"]

# Expose ports.
EXPOSE 5984

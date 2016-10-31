#
# Haproxy Dockerfile
#
# https://github.com/dockerfile/haproxy
#

# Pull base image.
FROM haproxy:alpine

# Install bash and python.
RUN apk add --no-cache bash python

# Add files.
ADD start.bash /haproxy-start

# Define working directory.
WORKDIR /etc/haproxy

# Allow to specify comma-separated list of COUCHDB_SERVERS from ENV
ENV COUCHDB_SERVERS="localhost:5984"

# Credentials
ENV COUCHDB_USERNAME=""
ENV COUCHDB_PASSWORD=""

# For the proxy to work, it's sometime necessary to set the hostname right
ENV COUCHDB_HOSTNAME=""

# Health check definition
ENV COUCHDB_CHECK=""

# Balancing algorithm definition
ENV COUCHDB_BALANCE=""

# Bind address and port
# (might be useful to customize when running in net=host mode)
ENV COUCHDB_BIND="*:5984"

# Define default command.
CMD ["bash", "/haproxy-start"]

# Expose ports.
EXPOSE 5984

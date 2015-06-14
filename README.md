## Haproxy Dockerfile

This repository contains **Dockerfile** of [Haproxy](http://haproxy.1wt.eu/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/jeko/couchdb-haproxy/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Base Docker Image

* ubuntu:14.04

### Installation

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/jeko/couchdb-haproxy/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull jeko/couchdb-haproxy`

### Usage

	docker run -d -p 5984:5984 -e COUCHDB_SERVERS=server1:15984,server2:25984 jeko/couchdb-haproxy

#### Authentication

To enable Basic HTTP authentication, set `COUCHDB_USERNAME` and `COUCHDB_PASSWORD`.


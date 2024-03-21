# Docker & Elastic

This repository contains a few examples of how to run Elasticsearch and Kibana 7.x and 8.x in Docker Compose for local development and testing. Using the official images and binding them to the default ports. Tested with the latest version of the Docker daemon.

Older examples for version 6.x and 7.x are in the [Elastic Stack 7 + 6 release](https://github.com/xeraa/elastic-docker/releases/tag/seven%2Bsix).





## Official

This is a minor adaptation of the [Docker Compose example from the official documentation](https://github.com/elastic/elasticsearch/blob/8.11/docs/reference/setup/install/docker/docker-compose.yml) with a self-signed certificate. The main difference is that the certificates are only generated once (automatically) and stored in the folder *official/.certs/*, so that they are easier to use.

Change into the *official/* folder and run Elasticsearch and Kibana.

* Start: `docker-compose up`
* Remove: `docker-compose down -v`

Connect to Elasticsearch at [https://localhost:9200](https://localhost:9200) and Kibana at [http://localhost:5601](http://localhost:5601) (without TLS).
To query Elasticsearch with cURL run `curl --cacert .certs/ca/ca.crt -u elastic https://localhost:9200` and enter the `ELASTIC_PASSWORD` password from the *official/.env* file.



## Insecure

**Don't do this.** But if you must: Change into the *insecure/* folder and run Elasticsearch and Kibana without authentication or TLS.

* Start: `docker-compose up`
* Remove: `docker-compose down -v`

Connect to Elasticsearch at [http://localhost:9200](http://localhost:9200) and Kibana at [http://localhost:5601](http://localhost:5601).

# Docker & Elastic

This repository contains a few examples how to run Elasticsearch, Kibana, Logstash, and Beats in Docker using the official images and binding them to the default ports. Tested with the latest version of the Docker daemon.

The credentials are always `elastic` and `changeme` when you connect to Kibana ([http://localhost:5601](http://localhost:5601)) or Elasticsearch ([http://localhost:9200](http://localhost:9200)).


## Minimal Elasticsearch + Kibana

* Start: `$ docker-compose -f elasticsearch-kibana-minimal.yml up`
* Remove: `$ docker-compose -f elasticsearch-kibana-minimal.yml down`


## Elasticsearch & Kibana

* Start: `$ docker-compose -f elasticsearch-kibana.yml up`
* Remove: `$ docker-compose -f elasticsearch-kibana.yml down`


## Elastic Stack

Note: You will need to increase the memory for all the containers to function correctly. Tested with 4GB instead of the default of 2GB.

* Start: `$ docker-compose -f elastic-stack.yml up`
* Remove: `$ docker-compose -f elastic-stack.yml down`

# Docker & Elastic

This repository contains a few examples how to run Elasticsearch, Kibana, Beats, and Logstash in Docker using the official images and binding them to the default ports. Tested with the latest version of the Docker daemon.

You connect to Kibana on [http://localhost:5601](http://localhost:5601) and Elasticsearch on [http://localhost:9200](http://localhost:9200).


## Elasticsearch & Kibana

* Start: `$ docker-compose up`
* Remove: `$ docker-compose down -v`


## App Search

Change into the *appsearch/* directory.
This demo includes Elasticsearch, Kibana, and App Search.

* Start: `$ docker-compose up`
* Remove: `$ docker-compose down -v`

App Search is running at [http://localhost:3002](http://localhost:3002).


## Elasticsearch Logs

Change into the *elasticsearch_logs/* directory.
This demo includes Elasticsearch, Kibana, and Filebeat to collect the Elasticsearch logs with the Elastic Stock. The blog post [Filebeat Modules with Docker & Kubernetes](https://xeraa.net/blog/2020_filebeat-modules-with-docker-kubernetes/) is built on top of this setup.

* Start: `$ docker-compose up`
* Remove: `$ docker-compose down -v`


## Full Stack

Change into the *full_stack/* directory.
This demo includes Elasticsearch, Kibana, Beats, Logstash, nginx, and MySQL and monitors all components with the Elastic Stack.

**Note:** You will need to increase the memory for all the containers to function correctly. Tested with 4GB instead of the default of 2GB.

* Start: `$ docker-compose up`
* Remove: `$ docker-compose down -v`


## Rolling Upgrade

Change into the *rolling_upgrade/* directory.
This demo shows a rolling upgrade from 6.x to 7.x. See the details in the [readme](./rolling_upgrade/).

* Start: `$ docker-compose up`
* Remove: `$ docker-compose down -v`


## Machine Learning

Change into the *machine_learning/* directory.
This demo includes Elasticsearch and Kibana as well as setting up the index patterns and dashboards for Filebeat. It assumes that you have a *log.json* file in the same directory, which will be imported automatically. Example entry:

```json
{"source.name":"/home/ec2-user/data/production-3/prod3elasticlogs/_logs/access-logs228.log","beat":{"hostname":"ip-172-31-5-206","name":"ip-172-31-5-206","version":"5.4.0"},"@timestamp":"2017-02-28T17:14:26.963Z","read_timestamp":"2017-06-20T08:47:54.189Z","fileset":{"name":"access","module":"nginx"},"nginx":{"access":{"body_sent":{"bytes":"32898"},"url":"/static/img/wrapper-footer.png","geoip":{"continent_name":"North America","city_name":"Chicago","location":{"lat":42.0106,"lon":-87.6686},"region_name":"Illinois","country_iso_code":"US"},"response_code":"404","user_agent":{"device":"Other","os_name":"Other","os":"Other","name":"Other"},"http_version":"1.1","method":"GET","remote_ip":"213.222.148.205"}},"prospector":{"type":"log"}}
```

**Note:** You will need to increase the memory for all the containers to function correctly. Tested with 4GB instead of the default of 2GB.

* Start: `$ docker-compose up`
* Remove: `$ docker-compose down -v`

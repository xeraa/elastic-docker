# Demo for a Rolling Upgrade from Elasticsearch 6.x to 7.x

* Start the cluster in version 6.8 with `docker-compose up`.
* Run the following steps in [Kibana's Console](http://localhost:5601/app/kibana#/dev_tools/console?_g=()), which also includes the required steps on the command line:

```js
GET /

GET _cat/nodes?h=id,version,master,name&v

GET _cluster/health

POST test/_doc
{
  "name": "Elasticsearch 6.8"
}

# Check the upgrade assistant

# Do not set to none since Kibana wants to create indices when starting up with 7
PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "new_primaries"
  }
}

POST _flush/synced

# Change .env and comment out the 6.x settings discovery.zen.*; only enable discovery.seed_hosts
# docker-compose up -d --no-deps elasticsearch3

GET _cat/nodes?h=id,version,master,name&v

GET test/_search

# Same procedure for elasticsearch2, elasticsearch 1, and kibana

PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": null
  }
}

POST test/_doc
{
  "name": "Elasticsearch 7.4"
}

GET test/_search

# Check the upgrade assistant and reindex

GET _cat/indices
```

* 🥳 the new cluster. And it's already prepared for the 8.0 migration 😉.
* Do a full cluster stop with `docker stop elasticsearch<X>` for all three nodes and then start them again.
* Scale down to only the elasticsearch1 node by running `POST /_cluster/voting_config_exclusions/elasticsearch3` and `POST /_cluster/voting_config_exclusions/elasticsearch2` and then stopping those nodes.
* Remove everything with `docker-compose down -v` and then restart it with `docker-compose up`, but disable `cluster.initial_master_nodes` (and `discovery.zen.minimum_master_nodes`) first. This will fail. Remove everything again, enable the `cluster.initial_master_nodes`, and see how it works now.

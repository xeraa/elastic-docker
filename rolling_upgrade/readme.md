# Demo for a Rolling Upgrade from Elasticsearch 6.x to 7.x

* Start the cluster in version 6.x with `docker-compose up`.
* Run the following steps in [Kibana's Console](http://localhost:5601/app/kibana#/dev_tools/console?_g=()), which also includes the required steps on the command line:

```js
GET /

GET _cat/nodes?h=id,version,master,name&v

GET _cluster/health

POST test/_doc
{
  "name": "Elasticsearch 6.7"
}

# Check the upgrade assistant

PUT _cluster/settings
{
  "transient": {
    "cluster.routing.allocation.enable": "none"
  }
}

POST _flush/synced

# Change .env and switch the commented and uncommented sections
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
  "name": "Elasticsearch 7.0"
}

# Check the upgrade assistant and reindex

GET _cat/indices
```

* 🥳 the new cluster
* Clean up with `docker-compose down -v`.

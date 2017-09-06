# Elastic Stack on Docker

This configuration is based on the [Elastic demo](https://github.com/elastic/examples/tree/master/Miscellaneous/docker).


## Getting Started

1. Docker version > v17.07.0 (Earlier versions may work but have not been tested)
1. Docker-Compose > 1.15.0
1. Ensuring the following ports are free on the host, as they are mounted by the containers:

    - `80` (nginx)
    - `5601` (Kibana)
    - `9200` (Elasticsearch)
    - `3306` (Mysql)

1. At least 3Gb of available RAM for Docker

The example file uses docker-compose v2 syntax.

To start the configuration: `docker-compose up`

To remove the configuration: `docker-compose down -v`

To check the status: `docker ps -a`
Note the `configure_stack` container will have exited on completion of the configuration of stack. This occurs before the Beats containers start.  Other containers should be "Up".

On confirming the stack is started, navigate to Kibana at [http://localhost:5601](http://localhost:5601). Assuming you haven't changed the default password, the default credentials are `elastic` and `changeme`.


## Architecture

The following containers are deployed:

* `Elasticsearch`
* `Kibana`
* `Filebeat` Collecting logs from the nginx and mysql containers. Also responsible for indexing the host's system and Docker logs.
* `Packetbeat` Monitoring communication between all containers with respect to HTTP, flows, DNS, and MySQL.
* `Heartbeat` Pinging all other containers over ICMP. Additionally monitoring Elasticsearch, Kibana, and nginx over HTTP. Monitoring MySQL over TCP.
* `Metricbeat` - Monitoring nginx and mysql containers using status check interfaces. Additionally, used to monitor the host system with respect CPU, disk, memory, and network. Monitors the host's Docker statistics with respect to disk, CPU, health checks, memory, and network.
* `nginx` - Supporting container for Filebeat (access & error logs) and Metricbeat (server-status).
* `MySQL` - Supporting container for Filebeat (slow & error logs), Metricbeat (status), and Packetbeat data.

In addition to the above containers, a `configure_stack` container is deployed at startup.  This is responsible for:

* Setting the Elasticsearch passwords.
* Importing dashboards.
* Inserting custom templates and ingest pipelines.

This container uses the Metricbeat images as it contains the required dashboards.


## Modules & Data

The following Beats modules are utilised in this stack example to provide data and dashboards:

1. Packetbeat, capturing traffic on all interfaces:
    - `dns` - port `53`
    - `http` - ports `9200`, `80`, `5601`
    - `icmp`
    - `flows`
    - `mysql` - port `3306`

1. Metricbeat
    - `docker` module with `container`, `cpu`, `diskio`, `healthcheck`, `info`, `memory`, `network` metricsets
    - `mysql` module with `status` metricset
    - `nginx` module with `stubstatus` metricset
    - `system` module with `core`,`cpu`,`load`,`diskio`,`filesystem`,`fsstat`,`memory`,`network`,`process`,`socket`

1. Heartbeat
    - `http` monitoring Elasticsearch (9200), Kibana (5601), and nginx (80)
    - `tcp` monitoring MySQL (3306)
    - `icmp` monitoring all containers

1. Filebeat
    - `system` module with `syslog` metricset
    - `mysql` module with `access` and `slowlog` `metricsets`
    - `nginx` module with `access` and `error` `metricsets`


## Technical notes

The following summarises some important technical considerations:

1. The Elasticsearch instances uses a named volume `esdata` for data persistence between restarts. It exposes HTTP port 9200 for communication with other containers.
1. Environment variable defaults can be found in the file `.env`.
1. The Elasticsearch container has its memory limited to 1GB. This can be adjusted using the environment parameter `ES_MEM_LIMIT`. Elasticsearch has a heap size of 512MB. This can be adjusted through the environment variable `ES_JVM_HEAP` and should be set to 50% of the `ES_MEM_LIMIT`.
1. The Elasticsearch password can be set via the environment variable `ES_PASSWORD`. This sets the password for the `elastic`, `logstash_system` and `kibana` user.
1. The Kibana container exposes the port 5601.
1. All configuration files can be found in the extracted folder `./config`.
1. In order for the containers `nginx` and `mysql` to share their logs with the Filebeat container, they mount the folder `./logs` relative to the extracted directory. Filebeat additionally mounts this directory to read the logs.
1. The Filebeat container mounts the host directories `/private/var/log` (OS X) in order to read the host's system logs.
1. The Filebeat container mounts the host directory `/var/lib/docker/containers` in order to access the container logs.  These are ingested using a custom prospector and processed by an ingest pipeline loaded by the container `configure_stack`.
1. The Filebeat registry file is persisted to the named volume `filebeatdata`, thus avoiding data duplication during restarts.
1. In order to collect Docker statistics, Metricbeat mounts the hosts `/var/run/docker.sock` directory.  For OS X this directory exists on the VM hosting docker.
1. Packetbeat is configured to use the hosts network, in order to capture traffic on the host system rather than that between the containers.
1. For data persistence between restarts the `mysql` container uses a named volume `mysqldata`.
1. The nginx and MySQL containers expose ports 80 and 3306 respectively on the host. **Ensure these ports are free prior to starting**
1. For OS X the stats of the VM hosting docker will be reported. This allows Metricbeat to use the `system` module report on disk, memory, network, and CPU of the host.
1. In for Filebeat to index the docker logs it mounts `/var/lib/docker/containers`. These JSON logs are ingested into the index `docker-logs-<yyyy-MM-dd>`.
1. On systems with POSIX file permissions, all Beats configuration files are subject to ownership and file permission checks. The purpose of these checks is to prevent unauthorized users from providing or modifying configurations that are run by the Beat. The owner of the configuration file must be either root or the user who is executing the Beat process. The permissions on the file must disallow writes by anyone other than the owner.  As we mount our configurations from the host, where the user is likely different than that used to run the container and the beat process, we disable this check for all beats with `-strict.perms=false`.


## Generating Data

The majority of the dashboards will simply populate due to inherent “noise” caused by the images. However, we do expose a few additional ports for interaction to allow unique generation.  These include:

* MySQL - port 3306 is exposed allowing the user to connect. Any subsequent Mysql traffic will in turn be visible in the dashboards “Filebeat MySQL Dashboard”, “Metricbeat MySQL” and “Packetbeat MySQL performance”.
* nginx - port 80. Currently we don’t host any content in nginx so requests will result in 404s.
* Docker Logs - any activity to the docker containers, including requests to Kibana, are logged. These logs are captured in JSON form and indexed into a index `docker-logs-<yyyy.mm.dd>`.



## Demo

1. Show the setup of the stack.
1. Start the stack.
1. Show `filebeat-*` and `docker-logs-*` in Discover in Kibana.
1. Show Metricbeat dashboards for Docker and processes.
1. Show the Packetbeat flow and HTTP dashboards and generate some HTTP requests.
1. Generate MySQL queries: `mysqlslap --host=127.0.0.1 --create-schema=mysqlslap --concurrency=5 --iterations=500 --user root -p`
1. See the Metricbeat and Packetbeat dashboards for MySQL.
1. TSVB: `docker.network.in` vs `docker.network.out` and split up by `docker.container.name`.

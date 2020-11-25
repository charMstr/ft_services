# NGINX CONTAINER

This readme is dedicated to the Grafana visualiser subpart of the ft\_services
project. (school project, at 42.)

## OVERVIEW

The grafana server is designed to run in a container build from scratch from a
light weight base image: alpine linux, and will then be deployed in a
kubernetes cluster. It will be connecting to a influxdb time-series database
and provide us with some nice monitoring visuals.

## IMPLEMENTATION DETAILS 

Grafana uses a defaults.ini file as default configuration, it should no
be touched.
Modifications to the defaults.ini config can be made though the use of a
grafana.ini file in which env variables are automatically replaced for us.

```
grafana-server --config <path\_to\_custom.ini file>
```

In previous versions of Grafana, you could only use the API for provisioning
data sources (our influxdb for example) and dashboards. Now you can use the
active provisioning system to load them up. These are refered
as so in the defaults.ini (or custom.ini):

_#folder that contains provisioning config files that grafana will apply on startup and while running.
provisioning = conf/provisioning_



Anonymous users can access the dashboard without loggin in,
but they role will only be "viewer". You can still login as
an admin in the top left corner.

_Note: Grafana uses an internal database to store its dashboards, a default
one is embeded within the server binary._

## RUNNING SERVICES IN THE SAME CONTAINER:

- grafana-server

## PORTS:

- 3000

## ENV VARIABLES (and their default values):

- \_\_GRAFANA\_ADMIN\_PASSWORD\_\_=password
- \_\_GRAFANA\_ADMIN\_NAME\_\_=user
- \_\_GRAFANA\_ANON\_LOGIN\_\_=true
- \_\_GRAFANA\_PORT\_\_=3000
- \_\_GRAFANA\_IP\_\_=172.18.0.4
- \_\_GRAFANA\_LOG\_LEVEL\_\_=info

_note: log level can either be: "debug", "info", "warn",
"error", "critical", default is "info".

- \_\_INFLUXDB\_DB\_NAME\_\_=telegraf\_mine
- \_\_INFLUXDB\_DB\_USER\_\_=user
- \_\_INFLUXDB\_DB\_PASSWORD\_\_=password
- \_\_INFLUXDB\_URL\_\_=http://172.18.0.2:8086

## LOGS

in our custom configuration file _grafana.ini_, the logs are made available to
the console, therefore collected by docker.
note: the level of logs can be cahnged with the env \_\_GRAFANA\_LOG\_LEVEL\_\_

## SOURCES

[configuring datasource and dashboards] (https://grafana.com/tutorials/provision-dashboards-and-data-sources/#1)

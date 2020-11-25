# TELEGRAF CONTAINER

This readme is dedicated to the telegraf container, it is a non mandatory part
of the ft\_services school project, at 42. but necessary to atain some
mandatory goals.

## OVERVIEW

The telegraf container will be deployed and will be scraping metrics within the
cluster for us. Those metrics will be fed into some other parts of the subject:
influxdb for storage and grafana for visualisation in fine.

## CONFIGURATION

Its configuration file allows us to let some environment variables within it,
as long as they respect the rules desctibes at the top of the file:
_telegraf.conf_

## RUNNING SERVICES IN THE SAME CONTAINER:

- telegraf

## IMPLEMENTATION DETAILS & SECURITY GOOD PRACTICE

You cannot launch telegraf if the influxdb is not listening on the url you
specified in its conf file.

In the kubernetes cluster it does not need a service object as the other
application won't be requesting it.

By default, if no database exists, telegraf will creat one name telegraf.

telegraf can be deployed either as a daemonset in the cluster to monitor the
entire cluster and its ressources, or it can be deployed as a side-car container
within pods (a telegraf container running next to your application container
within the same pods). For the latter there is a telegraf-operator already
existing, but its a per pod configuration, and its more designed to pull
metrics regarding the application itself. I chose to deploy my telegraf
container in the cluster, and use the _Kube.Inventory Plugin_ .

For this Pluggin to be allowed to pull certain metrics from the cluster, some
_role_ and _role binding_ kubernetes objects will need to be created: using the
concept of Role-based access control (RBAC)

Basically you creat a role, with a verb defining actions like _get, list..._
and with nouns like _pods, services, deployments, ..._

Then this role does nothing by itself, it needs to be binding to an account,
giving this account the privileges stated in the role.

_notes: Cluster role is a superset of role, according privileges within all
namespaces of the cluster. but we only use the default namespace in our
minikube context. The same applies for cluster role binding, a superset of role
binding_.

## RBAC:

to make sure RBAC api is running on your minkube: 
``` kubectl api-versions | grep rbac ```
otherwise start minikube with:
``` minikube start --extra-config=apiserver.authorization-mode=RBAC ```

## PORTS:

note: not used. no service in use.

## ENV VARIABLES (and their default values):

- \_\_INFLUXDB\_DB\_NAME\__=telegraf_mine
- \_\_INFLUXDB\_DB\_USER\_\_=user
- \_\_INFLUXDB\_DB\_PASSWORD\_\_=password

- \_\_INFLUXDB\_URL\_\_=http://172.18.0.2:8086
- \_\_LOGS\_WITH\_DEBUG\_=false

## LOGS

Logs are collected on stderr. see _logfile_ in configuration file for more
ddetails.

Also the outputs of the time data is redirected to stdout. you can see them
outgoing every x seconds.
it is a good idead to keep only the logs while debugging connection issues.

## RESSOURCES

[RBAC official documentation] (https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
[github kube\_inventory plugin] (https://github.com/influxdata/telegraf/blob/release-1.14/plugins/inputs/kube_inventory/README.md)

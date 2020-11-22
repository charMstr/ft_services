# METALLB CONFIGURATION

This readme is dedicated to the load-balancer implementation for our bare metal
kubernetes cluster, in the ft\_services project. (school project, at 42.)

## OVERVIEW

Normally when deploying our cluster, the external ip addresses are provided by
some cloud providers. Metallb allows use to get those addresses on bare metal
server.

## USAGE:

Even though metallb is there and the daemon and controller are deployed within
our cluster, we still need to deploy the configmap for it to run.
We will have to do that before deploying the services within the cluster.

## IMPLEMENTATIONS DETAILS

### LAYER 2
Since we are running only one node (thats our development tool limitation,
minikube). There is no point in using the BGP configuration (routing between
nodes). We will therefor use the layer 2 configuration. 
For the record, in this implementation when a request is made from the outside
world, only one node is selected (we have only one here so it does not make any
significant change) and the request is loadbalanced between pods existing only
into that node.

### IP RANGE

The ip range of address we could use must be within the _docker0_'s bridge
subnet.  This is true in our case because we run the cluster in the docker
engine and not within a VM.
The ip addresses that the docker engine will allocate and that will be able to
use the bridge gateway address must be in its subnet.

in our case the ip range of allocatable address by metallb is reduced to one
(subject of ft\_services), so that we can be sure we only get the ip we desire
but this address must lays within this _docker0_ subnet mask as explained.

### SINGLE IP

To implement the single ip.
The address pool range has been redure with the /32 CIDR in the configmap.
But the proper way would be to actually specify the ip address we wish to use
in our service yaml files. setting the _spec.loadBalancerIP_
To make sure several services can use the same ip:
also add the _metallb.universe.tf/allow-shared-ip_ annotation to services.

#### sources:
- [select configuration] (https://metallb.universe.tf/configuration/#layer-2-configuration)
- [select ip] (https://metallb.universe.tf/usage/)
- [ip address sharing] (https://metallb.universe.tf/usage/#ip-address-sharing)

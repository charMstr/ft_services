#!/bin/sh

kubectl delete -f secrets/
kubectl delete -f configmaps/nginx_configmap.yaml
kubectl delete -f configmaps/wp_phpma_configmap.yaml
kubectl delete -f yaml_files/

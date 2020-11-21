#!/bin/sh

#create all my secret objects.
kubectl apply -f secrets/

kubectl apply -f yaml_files/mysql_deployment_svc.yaml
kubectl apply -f configmaps/wp_phpma_configmap.yaml
kubectl apply -f yaml_files/wp_deployment_svc.yaml
kubectl apply -f yaml_files/phpma_deployment_svc.yaml

kubectl apply -f configmaps/nginx_configmap.yaml
kubectl apply -f yaml_files/nginx_deployment_svc.yaml

#!/bin/sh

kubectl apply -f secrets/
kubectl apply -f configmaps/mysql_configmap.yaml
kubectl apply -f yaml_files/mysql_deployment.yaml
kubectl apply -f configmaps/wp_phpma_configmap.yaml
kubectl apply -f yaml_files/wordpress_deployment.yaml

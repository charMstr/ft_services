#!/bin/sh

kubectl apply -f secrets/
kubectl apply -f yaml_files/mysql_deployment.yaml
kubectl apply -f configmaps/wp_phpma_configmap.yaml
sleep 2
kubectl apply -f yaml_files/wordpress_deployment.yaml

kubectl apply -f secrets/nginx_secret.yaml
kubectl apply -f configmaps/nginx_configmap.yaml
kubectl apply -f yaml_files/nginx_deployment.yaml

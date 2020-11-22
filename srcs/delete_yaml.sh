#!/bin/sh

kubectl delete -f secrets/
kubectl delete -f configmaps/
kubectl delete -f nginx/
kubectl delete -f mysql/
kubectl delete -f phpmyadmin/
kubectl delete -f wordpress/
kubectl delete -f metallb/

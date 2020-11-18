#!/bin/sh

kubectl delete -f secrets/
kubectl delete -f configmaps/
kubectl delete -f yaml_files/

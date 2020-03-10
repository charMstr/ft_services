#!/bin/sh
#note: your will need to source this script for the "eval $(minikube docker-env)"
#		to take effect in the terminal.

#start minikube
minikube start --vm-driver=virtualbox --disk-size=10g --cpus=3 --memory=2448
if [ `echo $?` != 0 ]
then
	echo "\033[2m command \"minikube start\" failed\033[m"	
	echo "--> exit"
	exit
fi
#make the dockerd available form within the minikube.
eval $(minikube docker-env)

# Build image now with the docker daemon from within the minikube VM
docker build -t my-image .

# Run in minikube
#kubectl run --generator=run-pod/v1 --rm -i --tty hey-pod --image=my-image --image-pull-policy=Never --port=80 --target-port=1000
#note: the --generator=run-pod/v1 is there because simply using "run" is deprecated
#note: to avoid exposing the pod in a second time, we can simply use the option --expose=true
#		and this will creat a service as well.
#note: --port='': The port that this container exposes.

#note++++: to run in the background:
kubectl run --generator=run-pod/v1 --attach=false -i --tty hey-pod --image=my-image --image-pull-policy=Never --port=80
# remove the --rm option, and add --attach=false.
#note:	you can reattach to the container in the pod with:
#		kubectl attach -it hey-pod
#		exit does not kill the container!


# create a service to expose the pod with an external IP adress
kubectl expose pod/hey-pod --type=NodePort
# note:
# --port='': The port that the service should serve on. Copied from the resource being exposed, if unspecified
# --target-port='': Name or number for the port on the container that the service should direct traffic to.      PROBABLY IN THE CASE THERE IS MORE THAN ONE CONTAINER IN A SINGLE POD.

#open the website from the command line:
minikube service hey-pod
#note:  minikube service hey-pod --url   --> just displays the url in the terminal
#		example output: http://192.168.99.115:31381
#note: doing a curl on that will open the page in the terminal: (it displaye the html tags etc.)
#		curl $(minikube service hey-pod --url) 

#now do some port forwarding between the host and the cluster:
#		kc port-forward pod/hey-pod 8080:80
# note:	this will allow us to hit localhost:8080
# note:	the address has to be above 1024 on localhost.
# note: just add a '&' at the end to run the command in the background.

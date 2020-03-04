#!/bin/sh
docker build --rm -t my-nginx .
#note: remove the -d if you want to debug this container. or attach...
docker run -dti -p 80:80 --rm  my-nginx

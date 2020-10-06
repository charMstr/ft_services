#!/bin/sh

echo "BUILDING IMAGE: my-ftps"
docker build -t my-ftps .

echo "\n\nNOW RUNNING CONTAINER"
docker run --rm -ti\
            -p 21:21 \
            -p 21000-21010:21000-21010 \
            -e USERS="exam|exam" \
			-v ~/Projects/ft_services_git/srcs/FTPS/:/ftp/exam \
            my-ftps
            #-e ADDRESS=ftp.site.domain \

#if you want to be in interactive mode: change '-d' to '-ti'
#also in the docker file add "&& bash" at then edn of entrypoint
#also in the start_vsftpd.sh add a '&' to run the exec command in backgrnd

#If you want to mount/share a volume between host and container:
#docker run -it -p 21:21 --rm -v ~/Projects/ft_services_git/srcs/FTPS/tmp:/tmp my-ftps

#if you want to then access your ftp server from terminal:
#  open ftp://exam:exam@localhost
# unfortunately it will be readonly so to open with an application other to the finder:
# open -a "Google Chrome" 'ftp://exam:exam@localhost'
# this will give the user:passwd@host

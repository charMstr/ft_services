#!/bin/sh

#### SSH setup ###
# correct right on folder and file For "root" user.
chmod 700 /root/.ssh
chmod 600 /root/.ssh/authorized_keys

# For root account, impossible to connect through public key if the password
# has not been set yet. weird but real!
echo 'root:dummy' | chpasswd &>/dev/null

#add ssh user: "user", with password: "password"
adduser -D $__SSH_USER__ &>dev/null
echo "$__SSH_USER__:$__SSH_PASSWORD__"|chpasswd &>dev/null

#we already place the authorized key in the /root/.ssh folder.
#do the same for new user in home directory.
#For secret authentication on user@<ip_adress_server> to work straight away,
# add the authorized_keys file into /home/user/.ssh folder.
cp /tmp/authorized_keys /home/$__SSH_USER__/.ssh/authorized_keys

#make sure the ownership and permissions are correct for user "user.
chmod 700 /home/$__SSH_USER__/.ssh
chmod 600 /home/$__SSH_USER__/.ssh/authorized_keys

#generate pairs of keys on host.
#(here 3 different types of encryption, For more options to client.)
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa


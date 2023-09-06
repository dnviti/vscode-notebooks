#!/bin/bash

# Add and Configure the default user
sudo useradd -m -s /bin/bash $SSH_USERNAME
sudo echo "${SSH_USERNAME}:${SSH_USERNAME}" | chpasswd
sudo adduser $SSH_USERNAME sudo

# Set ssh key
mkdir -p /home/$SSH_USERNAME/.ssh
echo "${SSH_KEY}" > /home/$SSH_USERNAME/.ssh/authorized_keys
sudo chown $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME/.ssh/authorized_keys
sudo chmod 600 /home/$SSH_USERNAME/.ssh/authorized_keys

# Give right permissions to the entire home directory
sudo chown -R $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME

# Start services ssh and code server
sudo /usr/sbin/sshd -D & \
sudo -u $SSH_USERNAME sh -c "export PASSWORD='${1}' && /usr/bin/code-server --bind-addr 0.0.0.0:8080 --auth password /work" & \
wait
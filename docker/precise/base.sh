#!/bin/bash

export RUNLEVEL=1
export DEBIAN_FRONTEND=noninteractive

echo "deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe" > /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe" >> /etc/apt/sources.list
apt-get -qy update

# add ssh
apt-get install -qy openssh-server
sed -i 's/start on filesystem/start on filesystem or dockerboot/' /etc/init/ssh.conf

# add dbus, need for upstart jobs
apt-get install -qy dbus
sed -i 's/start on local-filesystems/start on local-filesystems or dockerboot/' /etc/init/dbus.conf

# change /bin/mknod, need for openjdk-7-jdk => fuse
dpkg-divert --local --rename --add /sbin/mknod && ln -s /bin/true /sbin/mknod

# create user
useradd -m vexor -s /bin/bash
echo "vexor:vexor" | chpasswd
apt-get -qy install sudo
echo "vexor ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# setup ssh for vexor
mkdir -p /home/vexor/.ssh
chmod 0700 /home/vexor/.ssh
cat > /home/vexor/.ssh/config <<EOF
Host *
  ForwardAgent yes
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
EOF
chown -R vexor:vexor /home/vexor/.ssh

# fix locales
locale-gen en_US.UTF-8
dpkg-reconfigure -fnoninteractive locales
update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US"

# install python and modules, needed for ansible
apt-get install -qy python

#ENTRYPOINT ["/sbin/init", "--startup-event", "dockerboot"]


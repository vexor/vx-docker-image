#!/bin/bash

set -e
set -x

export RUNLEVEL=1
export DEBIAN_FRONTEND=noninteractive

echo "deb http://archive.ubuntu.com/ubuntu/ trusty main restricted universe" > /etc/apt/sources.list
echo "deb http://archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe" >> /etc/apt/sources.list
apt-get -qy update

# add ssh
apt-get install -qy openssh-server

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

# setup sshd
cat > /etc/ssh/sshd_config <<EOF
Port 22
Protocol 2
#ListenAddress 0.0.0.0

SyslogFacility AUTHPRIV
PermitRootLogin no
PasswordAuthentication yes
ChallengeResponseAuthentication yes
GSSAPIAuthentication no
GSSAPICleanupCredentials no
UsePAM yes
X11Forwarding no
#Banner /etc/motd
PrintLastLog no
PrintMotd no

Subsystem sftp /usr/lib/openssh/sftp-server
EOF

# fix locales
locale-gen --purge en_US.UTF-8
dpkg-reconfigure -fnoninteractive locales
update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US"

# install python and modules, needed for ansible
apt-get install -qy python

# remove unused services
rm -rf /etc/service/syslog-ng
rm -rf /etc/service/cron

apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

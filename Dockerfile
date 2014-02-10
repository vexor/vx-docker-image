# ssh

FROM ubuntu:12.04

ENV RUNLEVEL 1

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt precise main restricted universe" > /etc/apt/sources.list
RUN apt-get -qy update

# add ssh
RUN DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 apt-get install -qy openssh-server
RUN sed -i 's/start on filesystem/start on filesystem or dockerboot/' /etc/init/ssh.conf

# add dbus, need for upstart jobs
RUN DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 apt-get install -qy dbus
RUN sed -i 's/start on local-filesystems/start on local-filesystems or dockerboot/' /etc/init/dbus.conf

# change /bin/mknod, need for openjdk-7-jdk => fuse
RUN dpkg-divert --local --rename --add /sbin/mknod && ln -s /bin/true /sbin/mknod

# create user
RUN useradd -m vexor -s /bin/bash
RUN echo "vexor:vexor" | chpasswd
RUN apt-get -qy install sudo
RUN echo "vexor ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

# fix locales
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure -fnoninteractive locales
RUN update-locale LC_ALL="en_US.UTF-8" LANG="en_US.UTF-8" LANGUAGE="en_US"

# install python and modules, needed for ansible
RUN DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 apt-get install -qy python

ENTRYPOINT ["/sbin/init", "--startup-event", "dockerboot"]

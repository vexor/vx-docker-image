#!/bin/bash

set -e
set -x

/etc/my_init.d/00_regen_ssh_host_keys.sh

export RUNLEVEL=1
export DEBIAN_FRONTEND=noninteractive
export PYTHONUNBUFFERED=1

cd /tmp/provision

apt-get update
apt-get install -qy software-properties-common
apt-add-repository -y ppa:rquillo/ansible
apt-get update
apt-get install -qy ansible python-apt python-pycurl

ansible-playbook playbooks/site.yml -v -i playbooks/inventory -c local

apt-get purge -qy ansible python-apt python-pycurl vim vim-runtime

apt-get autoremove -qy
apt-get clean

rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
rm -rf /usr/share/man/* /usr/share/doc/*

apt-get update -qq

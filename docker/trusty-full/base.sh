#!/bin/bash

set -e
set -x

export RUNLEVEL=1
export DEBIAN_FRONTEND=noninteractive
export PYTHONUNBUFFERED=1

cd /tmp/provision

apt-get update
apt-get install -qy software-properties-common
apt-add-repository -y ppa:rquillo/ansible
apt-get update
apt-get install -qy ansible python-apt

ansible-playbook playbooks/site.yml -v -i playbooks/inventory -c local

apt-get purge -qy ansible python-apt
apt-get autoremove -qy
apt-get clean

rm -rf /tmp/* /var/tmp/*


#!/bin/bash

set -e

DOCKER="docker"

if [ -z $PREFIX ] ; then
  PREFIX=dmexe
fi

if [ -z $CONTAINER ] ; then
  echo "* Build SSH image"
  ${DOCKER} build -t $PREFIX/vexor-precise:latest .

  CONTAINER=$(${DOCKER} run -d $PREFIX/vexor-precise)
  echo "* Spawn container ${CONTAINER}"
fi

if [ -z $IMAGE_TAG ] ; then
  IMAGE_TAG=latest
fi

if [ -z $IMAGE_NAME ] ; then
  IMAGE_NAME=$PREFIX/vexor-precise-full
fi

ADDR=$(${DOCKER} inspect ${CONTAINER} | grep IPAddress | cut -d '"' -f 4)
echo "* Using container IPAddress ${ADDR}"

ANSIBLE_HOSTS=$(pwd)/.ansible_hosts
echo $ADDR > $ANSIBLE_HOSTS
export ANSIBLE_HOSTS
export ANSIBLE_HOST_KEY_CHECKING=False

if [ ! -z $TAGS ] ; then
  TAGS=" --tags ${TAGS}"
fi

ANSIBLE_OPTS="--ask-pass -u vexor -s ${TAGS}"

echo "* Run playbooks, type 'vexor' in 'SSH password:' prompt"
(cd playbooks && ansible-playbook site.yml $ANSIBLE_OPTS)

echo "* Kill container ${CONTAINER}"
$DOCKER kill $CONTAINER

echo "* Commit container ${CONTAINER} to ${IMAGE_NAME}:${IMAGE_TAG}"
$DOCKER commit ${CONTAINER} ${IMAGE_NAME}:${IMAGE_TAG}

echo "* DONE"


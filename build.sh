#!/bin/bash

set -e

case $1 in
  "trusty")
    packer build packer/docker/trusty.json
    ;;
  "trusty-full")
    packer build packer/docker/trusty-full.json
    ;;
  *)
    echo "Usage $0 (precise|precise-full)"
    exit 1
    ;;
esac

#!/bin/bash

set -e

case $1 in
  "precise")
    packer build packer/precise.json
    ;;
  "precise-full")
    packer build packer/precise-full.json
    ;;
  *)
    echo "Usage $0 (precise|precise-full)"
    exit 1
    ;;
esac

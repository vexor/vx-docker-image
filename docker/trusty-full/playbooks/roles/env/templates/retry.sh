#!/bin/bash

red='\e[0;31m'
NC='\e[0m' # No Color

cmd="$@"

for i in 1 2 3; do
  $cmd && break || (
    echo ""
    echo -ne "${red}The command \"${cmd}\" failed. Attempt ${i} of 3.${NC}\n"
    echo ""
    sleep 5
  )
done

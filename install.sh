#!/bin/bash

virt-install \
  --name k8s-node-1 \
  --ram 4096 \
  --vcpus 2 \
  --disk path=k8s-node-1.qcow2,format=qcow2 \
  --disk path=seed.iso,device=cdrom \
  --import \
  --os-variant ubuntu24.04 \
  --network network=default \
  --graphics none


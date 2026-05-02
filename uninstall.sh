#!/bin/bash

virsh undefine k8s-node-1
rm -f k8s-node-1.qcow2
rm -f seed.iso


#!/bin/bash

virsh undefine k8s-master
virsh undefine k8s-worker1
virsh undefine k8s-worker2

rm -f {master,worker1,worker2}.qcow2
rm -f base.qcow2

rm -f seed-{master,w1,w2}.iso


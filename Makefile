start:
	virsh start k8s-master
	virsh start k8s-worker-1
	virsh start k8s-worker-2

shutdown:
	virsh shutdown k8s-worker-1
	virsh shutdown k8s-worker-2
	virsh shutdown k8s-master

list:
	virsh list --all
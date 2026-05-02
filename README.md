# k8s-cluster

Example for running 1 node see [here](./node1).

running k8s cluster with 3 nodes:

- k8s-master-01
- k8s-worker-01
- k8s-worker-02

## Install

1. download ubuntu server img file `noble-server-cloudimg-amd64.img` from [here](https://cloud-images.ubuntu.com/noble/current/)

```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

2. create a copy as a base image

```bash
cp -p noble-server-cloudimg-amd64.img base.qcow2
```

3. create overlay images and resize them

```bash
qemu-img create -f qcow2 -b base.qcow2 master.qcow2
qemu-img create -f qcow2 -b base.qcow2 worker1.qcow2
qemu-img create -f qcow2 -b base.qcow2 worker2.qcow2
```

```bash
qemu-img resize master.qcow2 +60G
qemu-img resize worker1.qcow2 +150G
qemu-img resize worker2.qcow2 +150G
```

4. create ssh key

```bash
ssh-keygen -t ed25519 -C "k8s-int@mail123.com"
```

5. paste it into user-data file

6. install cloud-image-utils

```bash
sudo apt install cloud-image-utils
```

7. create seeds and run

master:

```bash
cloud-localds seed-master.iso user-data meta-master
virt-install \
  --name k8s-master \
  --ram 4096 \
  --vcpus 2 \
  --disk master.qcow2 \
  --disk seed-master.iso,device=cdrom \
  --import \
  --network network=default \
  --os-variant ubuntu24.04 \
  --graphics none
```

worker1:

```bash
cloud-localds seed-w1.iso user-data meta-w1
virt-install \
  --name k8s-worker-1 \
  --ram 4096 \
  --vcpus 2 \
  --disk worker1.qcow2 \
  --disk seed-w1.iso,device=cdrom \
  --import \
  --network network=default \
  --os-variant ubuntu24.04 \
  --graphics none
```

worker2:

```bash
cloud-localds seed-w2.iso user-data meta-w2
virt-install \
  --name k8s-worker-2 \
  --ram 4096 \
  --vcpus 2 \
  --disk worker2.qcow2 \
  --disk seed-w2.iso,device=cdrom \
  --import \
  --network network=default \
  --os-variant ubuntu24.04 \
  --graphics none
```

8. check if it was created successfully

```bash
virsh list --all
```

9. Initialize k8s cluster

```bash
virsh net-dhcp-leases default
```

master:

```bash
ssh ubuntu@<IP>
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

```bash
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Install flannel

```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

print join cmd:

```bash
kubeadm token create --print-join-command
```

worker{1,2}:

```bash
ssh ubuntu@<IP>
sudo kubeadm join <master-ip>:6443 ...
```

## Troubleshooting

1. reset and reboot a node:

```bash
sudo systemctl stop kubelet
sudo kubeadm reset -f
sudo rm -rf /etc/kubernetes /var/lib/kubelet /etc/cni/net.d
sudo reboot
```

2. setup hostname:

```bash
hostname
```

```bash
sudo hostnamectl set-hostname k8s-worker-1
echo "192.168.122.240 k8s-worker-1" | sudo tee -a /etc/hosts
```

## Uninstall

Run `./uninstall.sh`

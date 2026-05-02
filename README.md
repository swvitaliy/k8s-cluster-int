# k8s-cluster

## Install

1. download ubuntu server img file `noble-server-cloudimg-amd64.img` from [here](https://cloud-images.ubuntu.com/noble/current/)

```bash
wget https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
```

2. copy img file

```bash
qemu-img create -f qcow2 -b noble-server-cloudimg-amd64.img k8s-node-1.qcow2
```

3. disk resize

```bash
qemu-img resize k8s-node-1.qcow2 +20G
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

7. create seed.iso

```bash
cloud-localds seed.iso user-data meta-data
```

8. run install

```bash
./install.sh
```

9. check if it was created successfully

```bash
virsh list --all
```

10. get access using ssh

```bash
# get ip
virsh domifaddr k8s-node-1
```

```bash
ssh ubuntu@<IP>
```

## Uninstall

Run `./uninstall.sh`

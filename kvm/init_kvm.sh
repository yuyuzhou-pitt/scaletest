#!/bin/bash
current_ip=10.20.109.13
current_pwd=/home/cc/new/scaletest/kvm


sudo yum install qemu-kvm libvirt libvirt-python libguestfs-tools virt-install -y
mkdir -p /home/cc/exp/kvm
mkdir -p /home/cc/exp/images
scp "$current_ip":"$current_pwd"/centos7-kvm-console.raw /home/cc/exp/images
sudo mv /home/cc/exp/images/centos7-kvm-console.raw /var/lib/libvirt/images/
scp "$current_ip":"$current_pwd"/*.xml /home/cc/exp/images
cd /home/cc/exp/images/
sudo virsh define centos7-kvm-3.xml
#sudo virsh nodedev-detach pci_0000_01_00_0
#sudo virsh nodedev-detach pci_0000_01_00_1
#sudo virsh nodedev-detach pci_0000_01_00_2
#sudo virsh nodedev-detach pci_0000_01_00_3
#sudo virsh start centos7.0

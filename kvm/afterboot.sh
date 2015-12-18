#!/bin/bash
current_ip=10.20.109.13
current_pwd=/home/cc/new/scaletest/kvm

sudo rm -f /etc/exports
sudo systemctl stop firewalld
sudo service nfs restart
sudo echo "10.20.108.49 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAPIRmor60AmdqESC3NNm1Lc6k6sbPl5cbOgPfuY3GrlCl5TDNrc2q+hR05hQrd9qUYpEWZKUZ9OyB4JzBl7RtQ=" >> /home/cc/.ssh/known_hosts
sudo mount 10.20.108.49:/home/cc/exp/kvm/mantevo/ /home/cc/exp/kvm/mantevo/

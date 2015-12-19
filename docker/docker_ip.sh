#!/bin/bash

### Note: replace the xxx in IP address before using
ETHX=eno1 # host physical interface
VIRTUAL=virtual0 # virtual interface
# guest_private_ip
IP_GUEST=10.20.108.194
BROADCAST=10.20.109.255
MASK=23 #255.255.254.0
# docker_ip
# IP_DOCKER=172.17.0.1
# GW_DOCKER=172.17.42.1
DOCKER_HOME=~/exp/docker

### 1) Get the docker container internal IP
# sudo docker ps -a
CONTAINER_ID=`sudo docker ps |  grep -v CONTAINER | awk '{print $1}'`

if [ "x" == "x${CONTAINER_ID}" ]; then
    cd ${DOCKER_HOME}
    #sudo mount 10.20.108.49:/home/cc/exp/docker/mantevo/ ./mantevo/
    sudo docker load < ./centos7.tar.gz
    sudo docker images
    sudo docker run --privileged --cap-add=ALL -it -v /usr/bin/:/usr/sbin/ -v /home/cc/exp/docker/mantevo/:/home/cc/exp/docker/mantevo/ centos7 /bin/bash
    CONTAINER_ID=`sudo docker ps |  grep -v CONTAINER | awk '{print $1}'`
fi

### 2) Defining a new virtual interface on host 88.111 (already done on 88.110)
#sudo docker start ${CONTAINER_ID} # use a real container ID
IP_DOCKER=`sudo docker inspect ${CONTAINER_ID} | grep '"IPAddress"' | awk -F'"' '{print $4}'` # the internal IP as 172.17.0.xx

SET_VIRTUAl=`ip addr | grep ${VIRTUAL}`
if [ "x" == "x${SET_VIRTUAl}" ]; then
    sudo ip link add ${VIRTUAL} link ${ETHX} type macvlan mode bridge
    ip addr | grep ${VIRTUAL}   # a new interface virtual0@br0 shows up
    sudo ip address add ${IP_GUEST}/${MASK} broadcast ${BROADCAST} dev ${VIRTUAL}
    ip addr | grep ${VIRTUAL}   # the new interface configured with IP     
    sudo ip link set ${VIRTUAL} up     # start the interface
    ifconfig ${VIRTUAL}   # this interface shows up in ifconfig now
fi

sudo iptables -L
### 3) Setting up inbound routing/NAT
sudo iptables -t nat -N BRIDGE-VIRTUAL0    # create a new chain
sudo iptables -t nat -A PREROUTING -p all -d ${IP_GUEST} -j BRIDGE-VIRTUAL0
sudo iptables -t nat -A OUTPUT -p all -d ${IP_GUEST} -j BRIDGE-VIRTUAL0
sudo iptables -t nat -A BRIDGE-VIRTUAL0 -p all -j DNAT --to-destination ${IP_DOCKER}

### 4) Setting up outbound NAT
sudo iptables -t nat -I POSTROUTING -p all -s ${IP_DOCKER} -j SNAT --to-source ${IP_GUEST}

### 5) Ping another container IP from this container
#sudo docker attach 4a1a56e7ebc8
#[root@4a1a56e7ebc8 /]# ping xxx.xxx.88.113

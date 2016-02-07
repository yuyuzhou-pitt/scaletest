#!/bin/bash -x

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
if [ $# == 0 ];then
    echo "ERROR: Guest IP required."
    exit
else
    IP_GUEST=$1
fi

DOCKER_HOME=~/exp/docker
if [ "x" == "x${DOCKER_HOME}" ]; then
    mkdir -p ${DOCKER_HOME}
fi
MANTEVO=/home/cc/exp/baremetal/mantevo/
LOCAL_PATH=/home/cc/exp/baremetal/mantevo/
IMAGE_TAR=${LOCAL_PATH}centos7.tar.gz
DOCKER_NAME=centos7
#sudo umount -l ${MANTEVO}
#sudo mount 10.20.108.125:${MANTEVO} ${MANTEVO}
if [ "x" == "x${LOCAL_PATH}" ]; then
    mkdir -p ${LOCAL_PATH}
fi
#INIT_DOCKER=init_docker.sh

### 1) Get the docker container internal IP
# sudo docker ps -a

### clean up first 
sudo /bin/systemctl stop  docker.service
sudo ip link delete dev virtual0
sudo yum erase docker -y

sudo yum install docker -y
sudo /bin/systemctl start  docker.service
CONTAINER_ID=`sudo docker ps |  grep Up | awk '{print $1}'`
if [ "x" == "x${CONTAINER_ID}" ]; then
    #cd ${DOCKER_HOME}
    #sudo mount 10.20.108.49:/home/cc/exp/docker/mantevo/ ./mantevo/
    
    if [ -f "${IMAGE_TAR}" ]; then
        sudo docker load < ${IMAGE_TAR}
        DOCKER_NAME=centos7.0
    else
        sudo docker pull centos # get the latest docker image
        DOCKER_NAME=centos
        #sh -x ${INIT_DOCKER}
    fi
    #sudo docker images
    sudo docker create --privileged --cap-add=ALL -it -v /usr/bin/:/usr/bin -v /usr/sbin/:/usr/sbin/ -v ${MANTEVO}:${LOCAL_PATH} ${DOCKER_NAME} /bin/bash
    #sudo docker run --privileged --cap-add=ALL -it -v /usr/bin/:/usr/sbin/ -v /home/cc/exp/docker/mantevo/:/home/cc/exp/docker/mantevo/ centos7 /bin/bash
    CONTAINER_ID=`sudo docker ps -a | grep Created | awk '{print $1}'`
    sudo docker start ${CONTAINER_ID}
fi

if [ ! -f "${IMAGE_TAR}" ]; then
### Install necessary software
cat <<EOF > docker_mpi_setup.sh 
#!/bin/bash
HOSTNAME=`hostname`
yum install mpich-devel binutils-devel openssh.x86_64 openssh-server.x86_64 -y
echo "sshd:x:74:" >> /etc/group
echo "${IP_GUEST} ${HOSTNAME}" >> /root/.ip_host
echo "sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin" >> /etc/passwd
export LD_LIBRARY_PATH=:/usr/lib64/mpich/lib/
export PATH=${PATH}:/usr/lib64/mpich/bin/
ssh-keygen -A
/usr/sbin/sshd
ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''
echo "StrictHostKeyChecking no" >> ~/.ssh/config
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
EOF

tar -cv docker_mpi_setup.sh | sudo docker exec -i ${CONTAINER_ID} tar x -C /root/
sudo docker exec -it ${CONTAINER_ID} sh /root/docker_mpi_setup.sh
fi 

/usr/sbin/ip addr

### 2) Defining a new virtual interface on host 88.111 (already done on 88.110)
#sudo docker start ${CONTAINER_ID} # use a real container ID
IP_DOCKER=`sudo docker inspect ${CONTAINER_ID} | grep '"IPAddress"' | awk -F'"' '{print $4}'` # the internal IP as 172.17.0.xx

SET_VIRTUAl=`/usr/sbin/ip addr | grep ${VIRTUAL}`
if [ "x" == "x${SET_VIRTUAl}" ]; then
    sudo /usr/sbin/ip link add ${VIRTUAL} link ${ETHX} type macvlan mode bridge
    /usr/sbin/ip addr | grep ${VIRTUAL}   # a new interface virtual0@br0 shows up
    sudo /usr/sbin/ip address add ${IP_GUEST}/${MASK} broadcast ${BROADCAST} dev ${VIRTUAL}
    /usr/sbin/ip addr | grep ${VIRTUAL}   # the new interface configured with IP     
    sudo /usr/sbin/ip link set ${VIRTUAL} up     # start the interface
    /usr/sbin/ifconfig ${VIRTUAL}   # this interface shows up in ifconfig now
fi

#sudo iptables -L -v -n
### 3) Setting up inbound routing/NAT
sudo iptables -t nat -N BRIDGE-VIRTUAL0    # create a new chain
sudo iptables -t nat -A PREROUTING -p all -d ${IP_GUEST} -j BRIDGE-VIRTUAL0
sudo iptables -t nat -A OUTPUT -p all -d ${IP_GUEST} -j BRIDGE-VIRTUAL0
sudo iptables -t nat -A BRIDGE-VIRTUAL0 -p all -j DNAT --to-destination ${IP_DOCKER}

### 4) Setting up outbound NAT
sudo iptables -t nat -I POSTROUTING -p all -s ${IP_DOCKER} -j SNAT --to-source ${IP_GUEST}
sudo iptables -L -v -n

### 5) Ping another container IP from this container
#sudo docker attach 4a1a56e7ebc8
#[root@4a1a56e7ebc8 /]# ping xxx.xxx.88.113
#sudo docker exec ${CONTAINER_ID} ping 127.0.0.1

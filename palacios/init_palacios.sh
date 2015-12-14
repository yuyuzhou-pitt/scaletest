current_ip=10.20.108.49
current_pwd=/home/cc/new/scaletest/palacios



################ Download and compile palacios  ##########################

#mkdir -p /home/cc/exp/palacios
#cd /home/cc/exp/palacios/
#git clone http://essex.cs.pitt.edu/git/palacios.git
#git clone http://essex.cs.pitt.edu/git/petlib.git
#sudo yum install ncurses-devel.x86_64 -y
#sudo yum install glibc-static.x86_64 -y
#cd /home/cc/exp/palacios/palacios
#git checkout b2a9f42d84c00dc856822ff397e15e25aa1eab67
#scp "$current_ip":"$current_pwd"/config /home/cc/exp/palacios/palacios/.config
#make

################ Prepare Guest image ############################
#mkdir -p /home/cc/exp/images
#scp "$current_ip":"$current_pwd"/../ifcfg-ens2f0-1 /home/cc/exp/images
#scp "$current_ip":"$current_pwd"/centos7.raw /home/cc/exp/images
#scp "$current_ip":"$current_pwd"/centos7.xml /home/cc/exp/images
#virt-copy-in -a /home/cc/exp/images/centos7.raw /home/cc/exp/images//ifcfg-ens2f0 /etc/sysconfig/network-scripts/
#virt-cat -a /home/cc/exp/images/centos7.raw /home/cc/exp/images//ifcfg-ens2f0

cd /home/cc/exp/palacios/palacios
sudo insmod v3vee.ko
cd /home/cc/exp/palacios/palacios/linux_usr/
sudo ./v3_mem 8
sudo ./v3_pci -a nic 01:00.0
sudo ./v3_create -b /home/cc/exp/images/centos7.xml vm
sudo ./v3_launch /dev/v3-vm0

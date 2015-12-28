#current_ip=10.20.108.49
#current_pwd=/home/cc/new/scaletest/baremetal
#master_ip=10.20.108.49

#mkdir -p /home/cc/exp/baremetal/mantevo/script
#mkdir -p /home/cc/exp/baremetal/log
#mkdir -p /home/cc/exp/baremetal/mpich
#sudo yum install mpich -y
#cd /home/cc/exp/baremetal/mantevo/
#scp "$current_ip":"$current_pwd"/bashrc /home/cc/.bashrc
#sudo yum install nfs-utils -y
#chmod -R 777 /home/cc/exp/baremetal/mantevo
#sudo systemctl enable rpcbind
#sudo systemctl enable nfs-server
#sudo systemctl enable nfs-lock
#sudo systemctl start rpcbind
#sudo systemctl start nfs-server
#sudo systemctl start nfs-lock
sudo umount /home/cc/exp/baremetal/mantevo
sudo umount  /dev/hugepages/
sudo sysctl -w vm.nr_hugepages=0

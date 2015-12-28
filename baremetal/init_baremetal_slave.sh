current_ip=10.20.108.108
current_pwd=/home/cc/new/scaletest/baremetal
master_ip=10.20.108.108

mkdir -p /home/cc/exp/baremetal/mantevo/script
mkdir -p /home/cc/exp/baremetal/log
mkdir -p /home/cc/exp/baremetal/mpich
sudo yum install mpich -y
cd /home/cc/exp/baremetal/mantevo/
scp "$current_ip":"$current_pwd"/bashrc /home/cc/.bashrc
sudo yum install nfs-utils -y
chmod -R 777 /home/cc/exp/baremetal/mantevo
sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable nfs-lock
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start nfs-lock
sudo mount "$master_ip":/home/cc/exp/baremetal/mantevo /home/cc/exp/baremetal/mantevo
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/enabled" 
sudo bash -c "echo never > /sys/kernel/mm/transparent_hugepage/defrag"
#sudo sysctl -w vm.nr_hugepages=40960
#sudo mount -t hugetlbfs hugetlbfs /dev/hugepages

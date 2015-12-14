current_ip=10.20.108.49
current_pwd=/home/cc/new/scaletest/baremetal


#mkdir -p /home/cc/exp/baremetal/mantevo/script
#mkdir -p /home/cc/exp/baremetal/log
#mkdir -p /home/cc/exp/baremetal/mpich
#sudo yum install mpich mpich-devel.x86_64 -y
#cd /home/cc/exp/baremetal/mantevo/
#scp -r "$current_ip":"$current_pwd"/mantevo/* /home/cc/exp/baremetal/mantevo
#scp "$current_ip":"$current_pwd"/bashrc /home/cc/.bashrc
#sudo yum install nfs-utils -y
#chmod -R 777 /home/cc/exp/baremetal/mantevo
#sudo systemctl enable rpcbind
#sudo systemctl enable nfs-server
#sudo systemctl enable nfs-lock
#sudo systemctl start rpcbind
#sudo systemctl start nfs-server
#sudo systemctl start nfs-lock
scp "$current_ip":"$current_pwd"/exports /home/cc/exports
sudo mv /home/cc/exports /etc/exports
sudo service nfs restart
sudo exportfs -a

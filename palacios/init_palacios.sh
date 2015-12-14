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
#scp "$current_ip":"$current_pwd"/config /home/cc/exp/palacios/palacios/.config
#make

################ Prepare Guest image ############################
mkdir -p /home/cc/exp/images
scp "$current_ip":"$current_pwd"/../ifcfg-ens2f0-1 /home/cc/exp/images
scp "$current_ip":"current_pwd"/centos7.raw /home/cc/exp/images
scp "$current_ip":"current_pwd"/centos7.xml /home/cc/exp/images


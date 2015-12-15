#!/bin/bash -x

# Set up which experiment is running:
baremetal=1
docker=0
kvm=0
palacios=0

settle=0
clean=1


 read all the ip and mac info from file
filename="ip_list.txt"

Nums=-1
i=0
Host_Public_IP=()
Host_Private_IP=()
Guest_Private_IP=()
Guest_MAC_ADDR=()

while read -r line
do
    echo $line
    if [[ $line == '#'* ]]; then 
        echo $line
      else if [ $Nums == -1 ] ; then
               Nums=$line
               echo $Nums
           else if [ $i -lt $Nums ]; then
             set -- $line
             Host_Public_IP[$i]=$1
             Host_Private_IP[${i}]=$2
             Guest_Private_IP[${i}]=$3
             Guest_MAC_ADDR[${i}]=$4
             i=$[$i+1]
            fi
       fi
    fi
done < "$filename"

############ Generate all ifcfg file for guests ##########
i=0
while [ $i -lt $Nums ]; do
     echo ${Host_Public_IP[${i}]}
#    echo ${Host_Private_IP[${i}]}
#    echo ${Guest_Private_IP[${i}]}
#    echo ${Guest_MAC_ADDR[${i}]}
    cp ifcfg-ens2f0 ifcfg-ens2f0-"${i}"
    echo "IPADDR=${Guest_Private_IP[${i}]}" >> ifcfg-ens2f0-"${i}"
    echo "MACADDR=${Guest_MAC_ADDR[${i}]}" >> ifcfg-ens2f0-"${i}"
    echo ${Host_Private_IP[${i}]} >> hostfile
    i=$[$i+1]
done 

#################### Baremetal experiment ################
if [ $baremetal == 1 ]; then
   echo baremetal
   if [ $settle == 1 ]; then
       echo settle
       i=0
       ssh cc@${Host_Private_IP[${i}]} 'bash -s' < ./baremetal/init_baremetal_master.sh 
       i=$[$i+1]
       while [ $i -lt $Nums ]; do
           echo $i
           ssh cc@${Host_Private_IP[${i}]} 'bash -s' < ./baremetal/init_baremetal_slave.sh
       i=$[$i+1]
       done
    fi
    if [ $clean == 1 ]; then
       echo clean
    fi
fi

##################### Docker experiment ###################

if [ $docker == 1 ]; then
   echo docker
fi

##################### Run KVM experiment #####################
if [ $kvm == 1 ]; then
   echo kvm
fi


###################### Run Palacios experiment ###############
if [ $palacios == 1 ]; then
    #ssh cc@10.20.108.14 date
    ssh cc@10.20.108.14 'bash -s' < ./palacios/init_palacios.sh
fi

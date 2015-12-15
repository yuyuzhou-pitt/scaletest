#!/bin/bash
#used in latop

#for ip in `cat ./hostfile`; do
#    echo $ip
#    ssh -t cc@$ip ssh-keygen
#    sleep 5  
#done

#for ip in `cat ./hostfile`; do
#    echo $ip
#    ssh -t cc@$ip cat /home/cc/.ssh/id_rsa.pub >> ./log
#    sleep 20
#done


   #for ip in `cat ./host_internal`; do
   #     echo $ip  
   #  ssh-keyscan $ip |grep sha2 >> /home/cc/.ssh/known_hosts
   # done

    for ip in `cat ./host_internal`; do
        echo $ip
        scp /home/cc/.ssh/known_hosts cc@$ip:/home/cc/.ssh/known_hosts
        sleep 15
    done
    


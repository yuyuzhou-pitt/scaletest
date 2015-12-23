#!/bin/bash
#used in latop

#for ip in `cat ./hostfile`; do
#    echo $ip
#    ssh -t cc@$ip ssh-keygen
#    sleep 10  
#done

#for ip in `cat ./hostfile`; do
#    echo $ip
#    ssh -t cc@$ip cat /home/cc/.ssh/id_rsa.pub >> ./log
#    sleep 10
#done


for host in `cat ./hostfile`; do
    echo host=$host
    scp ./authorized_keys cc@$host:/home/cc/.ssh/authorized_keys
    sleep 10
done

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


for host in `cat ./host_internal`; do
    echo host=$host
    ssh -t cc@$host scp 10.20.109.13:/home/cc/test ./
    sleep 10
done

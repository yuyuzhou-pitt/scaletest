#!/bin/bash
# read all the ip and mac info from file

filename="ip_list.txt"


Nums=-1
i=0
Host_Public_IP=()
Host_Private_IP=()
Guest_Private_IP=()
Guest_MAC_ADDR=()

while read -r line
do
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


#echo ${Host_Public_IP[1]}
#echo ${Host_Private_IP[1]}
#echo ${Guest_Private_IP[1]}
#echo ${Guest_MAC_ADDR[1]}

# done 



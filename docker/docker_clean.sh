#!/bin/bash

sudo /bin/systemctl stop  docker.service
sudo ip link delete dev virtual0
sudo yum erase docker -y

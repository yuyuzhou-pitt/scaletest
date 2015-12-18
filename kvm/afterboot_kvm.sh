#!/bin/bash
current_ip=10.20.109.13
current_pwd=/home/cc/new/scaletest/kvm

echo "10.20.109.13 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBMog2E7oEc1GAH5X2DpU7AhOkc8qTflUlsVVhcWCl3NRjzfEnKHz9gTSSG1ItamSaxswI3sASL2PLuDoxM6iIeE=" > /home/cc/.ssh/known_hosts
scp "$current_ip":"$current_pwd"/afterboot.sh /home/cc/
sh /home/cc/afterboot.sh

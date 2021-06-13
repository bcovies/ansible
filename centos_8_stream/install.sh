#!/bin/bash
sudo yum update -y
sudo yum install -y git

sudo mkdir /mnt/{hdd,ssd}
sudo mount /dev/sda /mnt/ssd
sudo mount /dev/sdb /mnt/hdd


echo "/dev/sdb /mnt/hdd auto defaults 0 0 " >> /etc/fstab
echo "/dev/sda /mnt/ssd auto defaults 0 0 " >> /etc/fstab



sudo yum install epel-release -y
sudo yum install ansible -y
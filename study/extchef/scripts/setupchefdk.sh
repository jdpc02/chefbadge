#!/bin/bash
cd /tmp
curl -O https://packages.chef.io/files/stable/chefdk/2.5.13/el/7/chefdk-2.5.13-1.el7.x86_64.rpm
sudo rpm -Uvh chefdk-2.5.13-1.el7.x86_64.rpm
echo 'eval "$(chef shell-init bash)"' >> ~/.bash_profile
source ~/.bash_profile
cd ~
chef generate repo extchefrepo
cd extchefrepo
rm -rf cookbooks/example environments/example.json roles/example.json
sudo yum install -y yum-utils   device-mapper-persistent-data   lvm2
sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker
sudo yum install docker-ce-18.06.0.ce-3.el7
sudo systemctl start docker; sudo systemctl enable docker
sudo usermod -a -G docker $(whoami)
chef gem install kitchen-docker -v 2.7.0
read -p 'Run knife configure'

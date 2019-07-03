#!/bin/bash
cd /tmp
curl -O https://packages.chef.io/files/stable/chefdk/2.5.13/el/7/chefdk-2.5.13-1.el7.x86_64.rpm
sudo rpm -Uvh chefdk-2.5.13-1.el7.x86_64.rpm
echo 'eval "$(chef shell-init bash)"' >> ~/.b
source ~/.bash_profile
cd ~
chef generate repo extchefrepo
cd extchefrepo
rm -rf cookbooks/example environments/example.json roles/example.json
read -p 'Run knife configure'

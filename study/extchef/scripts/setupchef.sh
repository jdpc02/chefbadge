#!/bin/bash
sudo su -
cd /tmp
curl -O https://packages.chef.io/files/stable/chef-server/12.17.33/el/7/chef-server-core-12.17.33-1.el7.x86_64.rpm
rpm -Uvh chef-server-core-12.17.33-1.el7.x86_64.rpm
chef-server-ctl reconfigure
read -p 'Press [Enter] to continue'
chef-server-ctl user-create extchefuser ExtendChef User extchefuser@chef.io 'extchefuser1' --filename extchefuser.pem
chef-server-ctl org-create extchefllc 'Extend Chef LLC' --association_user extchefuser --filename extchefllc-validator.pem

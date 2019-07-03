#!/bin/bash
sudo curl -O https://packages.chef.io/files/stable/chef-server/12.17.33/el/7/chef-server-core-12.17.33-1.el7.x86_64.rpm -o /tmp/chef-server-core-12.17.33-1.el7.x86_64.rpm
sudo rpm -Uvh /tmp/chef-server-core-12.17.33-1.el7.x86_64.rpm
sudo chef-server-ctl reconfigure
read -p 'Press [Enter] to continue'
sudo chef-server-ctl user-create extchefuser ExtendChef User extchefuser@chef.io 'extchefuser1' --filename /tmp/extchefuser.pem
sudo chef-server-ctl org-create extchefllc 'Extend Chef LLC' --association_user extchefuser --filename /tmp/extchefllc-validator.pem

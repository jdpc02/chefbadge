#
# Cookbook:: ext_ec_nginx
# Recipe:: ohai
#
# Copyright:: 2019, The Authors, All Rights Reserved.
ohai_plugin 'extnginx'

ohai 'reload_extnginx' do
  plugin 'extnginx'
  action :nothing
  subscribes :reload, 'package[nginx]'
end

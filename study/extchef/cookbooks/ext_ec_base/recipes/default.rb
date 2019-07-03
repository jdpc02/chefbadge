#
# Cookbook:: ext_ec_base
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
include_recipe 'chef-client::config'

ohai 'reload_after' do
  action :nothing
  subscribes :reload, 'template[/etc/chef/client.rb]', :immediately
end

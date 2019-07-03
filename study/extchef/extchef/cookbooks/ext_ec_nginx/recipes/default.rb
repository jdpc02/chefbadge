#
# Cookbook:: ext_ec_nginx
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
if node['platform_family'] == 'rhel'
  package 'epel-release'
end
  
package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

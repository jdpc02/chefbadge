#
# Cookbook:: resourcetest
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

if node['platform_family'] == 'rhel'
  resourcetest_lnxres 'setupdisk' do
    action :create
  end
elsif node['platform_family'] == 'windows'
  resourcetest_winres 'setupdisk' do
    action :create
  end
end

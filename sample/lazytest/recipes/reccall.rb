#
# Cookbook:: lazytest
# Recipe:: reccall
#
# Copyright:: 2018, The Authors, All Rights Reserved.

execute 'echo myattribute to file normal' do
  command "echo #{node['myattribute']} > /tmp/normalecho.txt"
  action :run
end

execute 'echo myattribute to file lazy' do
  command lazy { "echo #{node['myattribute']} > /tmp/lazyecho.txt" }
  action :run
end

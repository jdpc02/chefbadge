#
# Cookbook:: setupmyenv
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

if platform_family?('windows')
  include_recipe 'setupmyenv::mywin'
elsif platform_family?('amazon', 'rhel', 'debian', 'ubuntu')
  puts "Working on the linux version\n"
  Chef::Log.info("Working on the linux version\n")
  # include_recipe 'setupmyenv::mylinux'
else
  puts "Running on an unsupported OS\n"
  Chef::Log.info("Running on an unsupported OS\n")
end

#
# Cookbook:: ext_dev_setup
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
package 'epel-release'

ext_dev_setup_init 'www.example.com'

execute 'from parent recipe' do
  command 'echo "from parent recipe"'
  action :nothing
end

execute 'run child resource' do
  command 'echo "Try to run child resource"'
  notifies :run, 'execute[echo from custom]', :immediately
end

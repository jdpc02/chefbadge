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

execute 'run from parent subscribe' do
  command 'echo "Try to call resource in init by subscription"'
  action :nothing
  subscribes :run, 'directory[/etc/chef/ohai/hints]'
end

puts "\nresource colletion:#{run_context.resource_collection.map { |item| item.name }}\n"


#
# Cookbook:: ext_ec_handlers
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
handlerp = "#{Chef::Config[:file_cache_path]}/json_logger.rb"

cookbook_file handlerp do
  source 'json_logger.rb'
  action :nothing
end.run_action(:create)

chef_handler 'ExtEcHandlers::JsonLogger' do
  source handlerp
  type({ exception: true, report: true })
  action :nothing
end.run_action(:enable)

cookbook_file '/etc/chef/client.d/event_handlers.rb' do
  source 'event_handlers.rb'
  action :nothing
end.run_action(:create)

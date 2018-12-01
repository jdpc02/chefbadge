#
# Cookbook:: lcd_web
# Recipe:: default
#
# Copyright:: 2017, Student Name, All Rights Reserved.
#

# %w( httpd net-tools ).each do |msiht|
#   package msiht
# end

# service 'httpd' do
#   action [ :enable, :start ]
# end

# package platform_package_httpd

# service platform_service_httpd do
#   action [ :enable, :start ]
# end

hello_httpd 'something' do
  greeting 'Hello'
  action :create
end

include_recipe 'lcd_web::user'

# template '/var/www/html/index.html' do
#   source 'index.html.erb'
#   owner 'apache'
#   group 'apache'
#   mode 0644
#   variables(
#     greeting: node['greeting'],
#     greeting_scope: node['greeting_scope'],
#     fqdn: node['fqdn']
#   )
# end

service 'httpd' do
  action :restart
  only_if { check_indexhtml? }
end

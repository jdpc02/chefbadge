#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'httpd'

template '/etc/httpd/conf/httpd.conf' do
  source 'httpd.conf.erb'
  variables(
    portnumber: node['apache']['port']
  )
end

service 'httpd' do
  action %i[enable start]
end

template 'var/www/html/index.html' do
  source 'index.html.erb'
end

include_recipe 'java'

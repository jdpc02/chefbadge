#
# Cookbook:: haproxy
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'haproxy'

nodeips = search(:node, 'name:*',
  :filter_result => { 'ip' => [ 'ipaddress' ] }

template '/etc/haproxy/haproxy.cfg' do
  source 'haproxy.cfg.erb'
  variables(
    nodeips: nodeips
  )
end

service 'haproxy' do
  action %i[enable start]
end

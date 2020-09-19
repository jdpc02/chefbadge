#
# Cookbook:: passattr
# Recipe:: saveattrib
#
# Copyright:: 2020, The Authors, All Rights Reserved.

file 'export all node attributes' do
  path '/tmp/.all_attributes.json'
  backup false
  content(
    JSON.pretty_generate(node)
  )
  mode '0775'
  sensitive true
end

node_cpu = node['cpu']
node_memory = node['memory']

file 'export just cpu and memory attributes' do
  path '/tmp/.specific_attributes.json'
  backup false
  content(
    Chef::JSONCompat.to_json_pretty(
      {
        'cpuinfo' => node_cpu,
        'meminfo' => node_memory,
      }
    )
  )
  mode '0775'
  sensitive true
end

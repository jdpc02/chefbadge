#
# Cookbook:: ext_exploring_resources
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
json_config '/home/cloud_user/extchefrepo/cookbooks/ext_exploring_resources/example.json' do
  content({ testing: 'this is a test', others: [1, 2, 3, 4] })
end

json_config '/home/cloud_user/extchefrepo/cookbooks/ext_exploring_resources/empty.json' do
  action :delete
end

json_config '/home/cloud_user/extchefrepo/cookbooks/ext_exploring_resources/valid.json' do
  content '{"foo": "bar", "baz": 1}'
end

json_config '/home/cloud_user/extchefrepo/cookbooks/ext_exploring_resources/invalid.json' do
  content 'NOT VALID JSON'
end


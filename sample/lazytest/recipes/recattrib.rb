#
# Cookbook:: lazytest
# Recipe:: recattrib
#
# Copyright:: 2018, The Authors, All Rights Reserved.

ruby_block 'set attribute' do
  block do
    node.default['myattribute'] = 'this is a test'
  end
  action :run
end

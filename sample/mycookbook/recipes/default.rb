#
# Cookbook:: mycookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

case node['platform']
when 'windows'
  include_recipe 'mycookbook::wintest'
when 'linux'
  include_recipe 'mycookbook::linuxtest'
end

#
# Cookbook:: mycookbook
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

case node['platform_family']
when 'windows'
  include_recipe 'mycookbook::wintest'
else
  include_recipe 'mycookbook::linuxtest'
end

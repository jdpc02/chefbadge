#
# Cookbook:: passattr
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'passattr::saveattrib'

file '/tmp/dummy_file.txt'

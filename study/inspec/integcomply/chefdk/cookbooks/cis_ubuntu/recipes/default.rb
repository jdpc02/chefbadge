#
# Cookbook:: cis_ubuntu
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
include_recipe 'audit::default'
include_recipe 'cis_ubuntu::users'

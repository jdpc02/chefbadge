#
# Cookbook:: lcd_web
# Recipe:: users
#
# Copyright:: 2017, Student Name, All Rights Reserved.
#

group 'developers'

user 'webadmin' do
  action :create
  uid '1110'
  gid 'developers'
  home '/home/webadmin'
  shell '/bin/bash'
end

#
# Cookbook:: users
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

user 'chef' do
  password 'chef'
  shell '/bin/bash'
end

template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
end

service 'sshd' do
  action :restart
  subscribes :reload, 'template[/etc/ssh/sshd_config]', :immediately
end

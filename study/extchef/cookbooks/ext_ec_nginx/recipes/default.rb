#
# Cookbook:: ext_ec_nginx
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.
extend ExtEcNginx::Helpers
#Chef::Resource.class_eval { include ExtEcNginx::Helpers }

if debian_based?
  apt_repository 'nginx' do
    extend ExtEcNginx::Helpers
    uri "http://nginx.org/packages/#{node['platform']}"
    components ['nginx']
    key nginx_key_url
  end
elsif rhel_based?
  yum_repository 'nginx' do
    extend ExtEcNginx::Helpers
    baseurl "http://nginx.org/packages/#{node['platform']}/#{node['platform_version'][0]}/$basearch/"
    gpgkey nginx_key_url
  end
end

package 'nginx'

service 'nginx' do
  action [:enable, :start]
end

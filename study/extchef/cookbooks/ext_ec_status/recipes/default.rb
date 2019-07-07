#
# Cookbook:: ext_ec_status
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

extend ExtEcNginx::Helpers

if rhel_based?
  execute "Key Info Printed" do
    extend ExtEcNginx::Helpers
    command "echo 'NGINX GPG key #{nginx_key_url}'"
  end
end

nginx_server 'status.example.com' do
  landing_page_content '<h2>Up Status&#13;&#10;</h2>'
end

#
# Cookbook:: ext_ec_status
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

nginx_server 'status.example.com' do
  landing_page_content '<h2>Up Status&#13;&#10;</h2>'
end

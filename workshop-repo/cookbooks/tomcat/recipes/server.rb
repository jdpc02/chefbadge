#
# Cookbook:: tomcat
# Recipe:: server
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package 'java-1.7.0-openjdk-devel'

group 'tomcat' do
 action :create
end

user 'tomcat' do
  action :create
  uid '10000'
  group 'tomcat'
  shell '/bin/bash'
end

remote_file '/tmp/apache-tomcat-8.5.20.tar.gz' do
  source 'http://mirror.cc.columbia.edu/pub/software/apache/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
  not_if { ::File.exist?('/tmp/apache-tomcat-8.5.20.tar.gz') }
end

# remote_file '/tmp/sample.war' do
#   source 'https://github.com/johnfitzpatrick/certification-workshops/blob/master/Tomcat/sample.war'
#   owner 'tomcat'
#   group 'tomcat'
#   mode '0755'
#   action :create
#   not_if { ::File.exist?('/tmp/sample.war') }
# end

directory '/opt/tomcat' do
  action :create
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  recursive true
end

execute 'extract tomcat' do
  command 'tar xvf /tmp/apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1'
  creates '/opt/tomcat/bin/catalina.sh'
  notifies :run, 'script[update permissions]', :immediately
end

template '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service.erb'
  notifies :run, 'execute[reload daemon]', :immediately
end

script 'update permissions' do
  interpreter 'bash'
  code <<-EOH
    sudo chown -R tomcat /opt/tomcat/
    sudo chgrp -R tomcat /opt/tomcat/conf
    sudo chmod g+rwx /opt/tomcat/conf
    sudo chmod g+r /opt/tomcat/conf/*
    sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
  EOH
  action :nothing
end

template '/opt/tomcat/conf/server.xml' do
  source 'server.xml.erb'
  variables({
    :connectorport => node['cp']
  })
  notifies :reload, 'service[tomcat restart]', :immediately
end

execute 'reload daemon' do
  command 'sudo systemctl daemon-reload'
  action :nothing
end

service 'tomcat initial' do
  action [:enable, :start]
  service_name 'tomcat.service'
end

service 'tomcat restart' do
  action :restart
  service_name 'tomcat.service'
  subscribes :reload, 'template[/etc/systemd/system/tomcat.service]', :immediately
end

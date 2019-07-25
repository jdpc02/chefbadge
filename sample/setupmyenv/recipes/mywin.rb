#
# Cookbook:: setupmyenv
# Recipe:: mywin
#
# Copyright:: 2019, The Authors, All Rights Reserved.

powershell_script 'Install Chocolatey' do
  code <<-EOH
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
  EOH
  not_if { File.exist?('C:/ProgramData/chocolatey/bin/choco.exe') }
end

packagelist = node['setupmyenv']['win']['packages']

packagelist.each do |instpkg|
  chocolatey_package instpkg do
    action :install
  end
end

windows_package 'Chef Workstation Install' do
  checksum node['setupmyenv']['win']['cwrkchk']
  source node['setupmyenv']['win']['cwrk']
  installer_type :msi
  options '/quiet /passive'
  action :install
  not_if { File.exist?('C:/opscode/chef-workstation/bin/start-chefws.ps1') }
end

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

packagelist = node['setupmyenv']['packages']['win']

packagelist.each do |instpkg|
  chocolatey_package instpkg do
    action :install
  end
end

windows_package 'Chef Workstation Install' do
  checksum node['setupmyenv']['chefwrkchk']['win']
  source node['setupmyenv']['chefwrk']['win']
  installer_type :msi
  options '/quiet /passive'
  action :install
end

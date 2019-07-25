#
# Cookbook:: setupmyenv
# Recipe:: mylinux
#
# Copyright:: 2019, The Authors, All Rights Reserved.

case node['platform']
when 'amazon', 'redhat', 'centos'
  packagelist = node['setupmyenv']['linux']['rhpkgs']
  chefworkstation = node['setupmyenv']['linux']['cwrkrh']
  chksum = node['setupmyenv']['linux']['cwrkrhchk']
  cwfile = '/tmp/chef-workstation.rpm'
end

packagelist.each do |instpkg|
  package instpkg do
    action :install
  end
end

remote_file cwfile do
    source chefworkstation
    checksum chksum
    action :create
end

package 'chef-workstation' do
  source cwfile
end

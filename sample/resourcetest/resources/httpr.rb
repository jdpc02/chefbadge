# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :linuxhttp

property :someprop, String, name_property: true
property :thisurl, String, default: 'mylocalnode.local.loc'

case node['platform_family']
when 'rhel'
  webpkg = 'httpd'
when 'debian'
  webpkg = 'apache2'
end

default_action :create

action :create do
  execute 'IsWebRunning' do
    command "systemctl status #{webpkg} | grep running > #{Chef::Config[:file_cache_path]}/IsWebRunning.txt"
    ignore_failure true
  end.run_action(:run)

  chkweb = ::File.read("#{Chef::Config[:file_cache_path]}/IsWebRunning.txt").chomp
  if chkweb.to_s.strip.empty?
    package webpkg

    case webpkg
    when 'httpd'
      bash 'enable firewall rules for httpd' do
        code <<-EOH
          firewall-cmd --permanent --add-port=80/tcp
          firewall-cmd --permanent --add-port=443/tcp
          firewall-cmd --reload
        EOH
        only_if 'firewall-cmd --state'
      end

      service 'httpd' do
        supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
      end    
    when 'apache2'
      bash 'enable firewall rules for apache2' do
        code <<-EOH
          ufw allow 'Apache Full'
        EOH
      end
    end
  else
    puts "#{webpkg} is running"    
  end
end

action :selfsignedcert do
end

action :letsencryptcert do
end

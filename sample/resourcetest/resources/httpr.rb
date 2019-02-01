# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
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
      command "systemctl status #{webpkg} | grep running > /tmp/IsWebRunning.txt"
      action :run
  end

  chkweb = ::File.read('/tmp/IsWebRunning.txt').chomp
  if chkweb.to_s.strip.empty?
    package webpkg

    case webpkg
    when 'httpd'
      script 'enable firewall rules for httpd' do
        code <<-EOH
          sudo firewall-cmd --permanent --add-port=80/tcp
          sudo firewall-cmd --permanent --add-port=443/tcp
          sudo firewall-cmd --reload
        EOH
      end

      service 'httpd' do
        supports :status => true, :restart => true, :reload => true
        action [ :enable, :start ]
      end    
    when 'apache2'
      script 'enable firewall rules for apache2' do
        code <<-EOH
          sudo ufw allow 'Apache Full'
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

module ExtEcNginx
  class ExtNginxServer < Chef::Resource
    resource_name :nginx_server

    property :host, String, name_property: true
    property :static_path, String
    property :landing_page_content, String
    property :srcbook, String, default: 'ext_ec_nginx'

    action_class { include ExtEcNginx::Helpers }

    action :create do
      package 'nginx'

      service 'nginx' do
	action [:start, :enable]
      end

      static_path = new_resource.static_path || "/var/www/#{new_resource.host}"

      directory static_path do
	recursive true
      end

      template "/etc/nginx/conf.d/#{new_resource.host}.conf" do
	source "nginx-server.conf.erb"
	cookbook new_resource.srcbook
	variables(
	  host: new_resource.host,
	  static_path: static_path
	)
	notifies :reload, 'service[nginx]'
      end

      if new_resource.landing_page_content
	file "#{static_path}/index.html" do
	  content new_resource.landing_page_content
	end
      end
    end

    action :delete do
      static_path = new_resource.static_path || "/var/www/#{new_resource.host}"

      directory static_path do
	recursive true
	action :delete
      end

      file "/etc/nginx/conf.d/#{new_resource.host}.conf" do
	action :delete
      end
    end
  end
end

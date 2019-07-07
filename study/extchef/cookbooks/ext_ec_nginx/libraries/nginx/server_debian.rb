module ExtEcNginx
  class ExtNginxServerDebian < ExtNginxServer
    resource_name :nginx_server
    provides :nginx_server, platform_family: 'debian'

    action :create do
      apt_repository 'nginx' do
        extend ExtEcNginx::Helpers
        uri "http://nginx.org/packages/#{node['platform']}"
        components ['nginx']
        key nginx_key_url
      end

      super()
    end
  end
end

module ExtEcNginx
  class ExtNginxServerRhel < ExtNginxServer
    resource_name :nginx_server
    provides :nginx_server, platform_family: 'rhel'

    action :create do
      yum_repository 'nginx' do
        extend ExtEcNginx::Helpers
        baseurl "http://nginx.org/packages/#{node['platform']}/#{node['platform_version'][0]}/$basearch/"
        gpgkey nginx_key_url
      end

      super()
    end
  end
end

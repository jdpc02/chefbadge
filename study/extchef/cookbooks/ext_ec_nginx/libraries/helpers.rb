module ExtEcNginx
  module Helpers
    def debian_based?
      node['plaform_family'] == 'debian'
    end

    def rhel_based?
      node['plaform_family'] == 'rhel'
    end

    def nginx_key_url
      'http://nginx.org/keys/nginx_signing.key'
    end
  end
end

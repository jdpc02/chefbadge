# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :host, String, name_property: true
property :content, String

action :create do
  nginx_server new_resource.host do
    if new_resource.content
      landing_page_content new_resource.content
    end
  end

  directory '/etc/chef/ohai/hints' do
    recursive true
  end

  json_config "/etc/chef/ohai/hints/#{new_resource.host}.json" do
    content({ host: new_resource.host })
  end
end


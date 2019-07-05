# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :host, String, name_property: true
property :content, String

action :create do
  execute 'echo from init resource' do
    command 'echo "from same init resource"'
    action :nothing
  end

  execute 'echo from custom' do
    command 'echo "from child init"'
    action :nothing
  end

  nginx_server new_resource.host do
    if new_resource.content
      landing_page_content new_resource.content
    end
  end

  directory '/etc/chef/ohai/hints' do
    recursive true
    notifies :run, 'execute[echo from init resource]', :immediately
  end

  json_config "/etc/chef/ohai/hints/#{new_resource.host}.json" do
    content({ host: new_resource.host })
    notifies :run, 'execute[from parent recipe]', :immediately
  end

  puts "\ninit resource colletion:#{run_context.resource_collection.map { |item| item.name }}\n"
end


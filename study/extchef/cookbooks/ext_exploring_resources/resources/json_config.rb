# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :json_config

property :path, String, name_property: true
property :content, [Hash, String], required: true, callbacks: {
  'check valid JSON' => lambda { |content|
     return true if content.is_a?(Hash)
     begin
       JSON.parse(content)
     rescue
       false
     end
  }
}

default_action :create

action :delete do
  puts "\n\n Removing the config\n\n"
end

action :create do
  puts "\n\n Setting up the config with #{new_resource.content} \n\n"
end


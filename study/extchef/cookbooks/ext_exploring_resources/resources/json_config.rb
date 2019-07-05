# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :json_config

property :path, String, name_property: true
property :content, [Hash, String], callbacks: {
  'check valid JSON' => lambda { |content|
     content.is_a?(Mash)
  }
}, coerce: lambda { |content|
   return Mash.new(content) if content.is_a?(Hash)
   begin
     Mash.new(JSON.parse(content))
   rescue
     content
   end
}

default_action :create

load_current_value do
  if ::File.exists?(path)
    myjson = ::File.open(path, 'r')
    content JSON.parse(myjson.read)
  end
end

action :delete do
  if ::File.exists?(new_resource.path)
    converge_by "Removing the config #{new_resource.path}" do
      ::FileUtils.rm(new_resource.path)
    end
  end
end

action :create do
  converge_if_changed do
    puts "Setting up the config with #{new_resource.content}"
    file = ::File.open(new_resource.path, 'w')
    if new_resource.content.is_a?(String)
      file.write(new_resource.content)
    else
      file.write(new_resource.content.to_json)
    end
  end
end


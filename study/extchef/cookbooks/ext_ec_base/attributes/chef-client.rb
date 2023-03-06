node.default['ohai']['disabled_plugins'] = [
  :Perl,
  :VMware,
  :Azure,
]

node.default['chef_client']['config']['automatic_attribute_blacklist'] = [
  'languages',
]

node.default['chef_client']['load_gems']['json_logger'] = {
  require_name: "#{Chef::Config[:file_cache_path]}/json_logger.rb",
}

node.default['chef_client']['config']['start_handlers'] = [
  {
    class: 'ExtEcHandlers::JsonLogger',
    arguments: [],
  },
]

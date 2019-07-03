node.default['ohai']['disabled_plugins'] = [
  :Perl,
  :VMware,
  :Azure
]

node.default['chef_client']['config']['automatic_attribute_blacklist'] = [
  'languages'
]

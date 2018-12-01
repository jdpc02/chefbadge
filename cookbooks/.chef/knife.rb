current_dir = File.dirname(__FILE__)
log_level                 :info
log_location              STDOUT
node_name                 "myuser"
client_key                "/Users/ncamara/code/learningchef/chef-repo/.chef/myuser.pem"
validation_client_name    "learningchef-validator"
validation_key            "/Users/ncamara/code/learningchef/chef-repo/.chef/learningchef-validator.pem"
chef_server_url           "https://server-centos65.vagrantup.com/organizations/learningchef"
cache_type                'BasicFile'
cache_options( :path => '/Users/ncamara/code/learningchef/chef-repo/.chef/checksums' )
cookbook_path             ['/Users/ncamara/code/learningchef/chef-repo/cookbooks']

cookbook_path [ '/home/user/code/chefbadge/clcdb/chef/cookbooks/']
local_mode true
if File.basename($PROGRAM_NAME).eql?('chef') && ARGV[0].eql?('generate')
  chefdk.generator.license = "all_rights"
  chefdk.generator.copyright_holder = "Student Name"
  chefdk.generator_cookbook = "/home/user/code/chefbadge/clcdb/cookbooks/lcd_origin"
  chefdk.generator.email = "you@example.com"
  chefdk.generator_cookbook = "/home/user/code/chefbadge/clcdb/generator/lcd_origin"
end

#
# Chef Documentation
# https://docs.chef.io/libraries.html
#

#
# This module name was auto-generated from the cookbook name. This name is a
# single word that starts with a capital letter and then continues to use
# camel-casing throughout the remainder of the name.
#

module LcdWebCookbook
  module Helpers
    def platform_package_httpd
      case node['platform']
      when 'centos' then 'httpd'
      when 'ubuntu' then 'apache2'
      end
    end

    def platform_service_httpd
      case node['platform']
      when 'centos' then 'httpd'
      when 'ubuntu' then 'apache2'
      end
    end
  end
end

Chef::DSL::Recipe.include(LcdWebCookbook::Helpers)
Chef::Resource.include(LcdWebCookbook::Helpers)

#
# The module you have defined may be extended within the recipe to grant the
# recipe the helper methods you define.
#
# Within your recipe you would write:
#
#     extend LcdWeb::HelpersHelpers
#
#     my_helper_method
#
# You may also add this to a single resource within a recipe:
#
#     template '/etc/app.conf' do
#       extend LcdWeb::HelpersHelpers
#       variables specific_key: my_helper_method
#     end
#

name 'lcd_haproxy'
maintainer 'Student Name'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures lcd_haproxy'
long_description 'Installs/Configures lcd_haproxy'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

depends 'haproxy', '= 3.0.2'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/lcd_haproxy/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/lcd_haproxy'

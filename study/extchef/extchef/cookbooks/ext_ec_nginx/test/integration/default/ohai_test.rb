# InSpec test for recipe ext_ec_nginx::ohai

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('ohai -d /tmp/kitchen/ohai/plugins extnginx') do
  its(:stdout) { should include('nginx version: nginx/1.12.2') }
end

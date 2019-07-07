# InSpec test for recipe ext_ec_nginx::default

# The InSpec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

if os.redhat?
  describe file('/etc/yum.repos.d/nginx.repo') do
    it { should exist }
  end
end

describe package('nginx') do
  it { should be_installed }
  its('version') { should include '1.14.0' }
end

describe service('nginx') do
  it { should be_running }
  it { should be_enabled }
end

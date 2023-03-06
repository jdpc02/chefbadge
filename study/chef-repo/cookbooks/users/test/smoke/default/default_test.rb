# Inspec test for recipe users::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('chef') do
  it { should exist }
  its('shell') { should eq '/bin/bash' }
end

describe file('/etc/ssh/sshd_config') do
  it { should exist }
  its('content') { should match /PasswordAuthentication yes/ }
end

describe service('sshd') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

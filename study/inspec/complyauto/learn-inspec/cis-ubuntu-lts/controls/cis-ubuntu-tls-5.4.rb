control 'cis-ubuntu-lts-5.4.4' do
  impact 0.5
  title 'Check default user mask is set to 027 or more restrictive'
  desc 'Default umask for files created by users'
  describe file('/etc/bash.bashrc') do
    its('content') { should match /^umask 027/ }
  end
  describe file('/etc/profile') do
    its('content') { should match /^umask 027/ }
  end
end

# copyright: 2018, The Authors

title 'nginx profile'

iparams = yaml(content: inspec.profile.file('iparams.yml')).params
reqver = iparams['nginxver']
reqmods = iparams['nginxmod']

control 'nginx-version' do
  impact 1.0
  title 'nginx version'
  desc 'Checking nginx version is correct'
  describe nginx do
    its('version') { should cmp >= reqver }
  end
end

control 'nginx-modules' do
  impact 1.0
  title 'nginx modules'
  desc 'Checking nginx modules are installed'
  # describe nginx do
  #   reqmods.each do |mod|
  #     its('modules') { should include mod }
  #   end
  # end
  reqmods.each do |mod|
    describe nginx do
      its('modules') { should include mod }
    end
  end
end

control 'nginx-conf' do
  impact 1.0
  title 'nginx.conf file check'
  desc 'config file is owned by root, writable only by root and not readable by anyone else'
  describe file('/etc/nginx/nginx.conf') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should_not be_readable.by('others') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable.by('others') }
  end
end

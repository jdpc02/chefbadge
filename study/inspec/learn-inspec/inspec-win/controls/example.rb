# encoding: utf-8
# copyright: 2018, The Authors

# inspec exec inspec-win -t winrm://Administrator@hostname <-p 'Password' | --password 'Password'>

title 'client service check'

control 'client-svc-check' do
  impact 0.7
  title 'Check Client Services'
  desc 'Does the DHCP and DNS client conform to standards'
  describe service('DHCP Client') do
    it { should be_installed }
    it { should be_running }
  end

  script = <<-EOH
    (Get-Service | Where-Object { $_.Name -eq 'Dnscache'}).Status
  EOH

  describe powershell(script) do
    its('stdout') { should eq "Running\r\n" }
    its('stderr') { should eq '' }
  end
end

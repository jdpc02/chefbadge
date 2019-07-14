control 'srg-os-999999' do
  impact 0.5
  title 'SRG-OS-999999: verify gshadow is owned by root'
  desc '[SRG-OS-999999] verify gshadow is owned by root'
  describe file('/etc/gshadow') do
    it { should be_owned_by 'root'}
  end
end

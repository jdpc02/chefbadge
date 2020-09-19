# InSpec test for recipe passattr::saveattrib

# The InSpec reference, with examples and extensive documentation, can be
# found at https://docs.chef.io/inspec/resources/

require_relative '../helpers/passattrib'

control 'Testing_Attribs_From_Cookbook' do
  impact 1.0
  title 'Memory Check'
  if memtotal > 1024
    describe file('/tmp/dummy_file.txt') do
      it { should exist }
    end
  end
end

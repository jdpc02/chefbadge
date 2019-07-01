# # encoding: utf-8

# Inspec test for recipe lcd_web::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# %w[httpd net-tools].each do |thism|
  describe package('httpd') do
    it { should be_installed }
  end
# end

describe service('httpd') do
  it { should be_enabled }
  it { should be_running }
end

# # encoding: utf-8

# Inspec test for recipe lcd_web::users

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe user('webadmin') do
  it { should exist }
  its('group') { should eq 'developers' }
end

describe group('developers') do
  it { should exist }
end

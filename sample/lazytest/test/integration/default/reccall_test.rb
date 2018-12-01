# # encoding: utf-8

# Inspec test for recipe lazytest::reccall

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/tmp/normalecho.txt') do
  it { should exist }
  its('content') { should cmp /\s/i }
end

describe file('/tmp/lazyecho.txt') do
  it { should exist }
  its('content') { should cmp /this is a test/i }
end

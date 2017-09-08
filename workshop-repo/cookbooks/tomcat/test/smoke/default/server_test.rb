# # encoding: utf-8

# Inspec test for recipe tomcat::server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# unless os.windows?
  # This is an example test, replace with your own test.
#  describe user('root'), :skip do
#    it { should exist }
#  end
# end

# This is an example test, replace it with your own test.
# describe port(80), :skip do
#  it { should_not be_listening }
# end

describe package('java-1.7.0-openjdk-devel') do
  it { should be_installed }
end

describe group('tomcat') do
  it { should exist }
end

describe user('tomcat') do
  it { should exist }
  its('uid') { should eq 10000 }
  its('group') { should eq 'tomcat' }
  its('shell') { should eq '/bin/bash' }
end

describe directory('/opt/tomcat') do
  it { should exist }
end

describe file('/opt/tomcat/RUNNING.txt') do
  it { should be_file }
  its('content') { should match /Running The Apache Tomcat 8.5 Servlet/}
end

describe directory('/opt/tomcat/conf') do
  it { should exist }
  its('group') { should eq 'tomcat' }
  its('mode') { should eq 504 }
end

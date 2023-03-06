# Inspec test for recipe tomcat::server

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

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
  its('content') { should match /Running The Apache Tomcat 8.5 Servlet/ }
end

describe directory('/opt/tomcat/conf') do
  it { should exist }
  its('group') { should eq 'tomcat' }
  its('mode') { should eq 504 }
end

describe file('/opt/tomcat/conf/server.xml') do
  it { should be_file }
  its('group') { should eq 'tomcat' }
  it { should be_readable.by('group') }
end

describe bash('stat -c "%U" /opt/tomcat/conf/*') do
  its('stderr') { should eq '' }
  its('stdout') { should match /tomcat/ }
end

describe directory('/opt/tomcat/webapps') do
  it { should exist }
  it { should be_owned_by 'tomcat' }
end

describe directory('/opt/tomcat/work') do
  it { should exist }
  it { should be_owned_by 'tomcat' }
end

describe directory('/opt/tomcat/temp') do
  it { should exist }
  it { should be_owned_by 'tomcat' }
end

describe directory('/opt/tomcat/logs') do
  it { should exist }
  it { should be_owned_by 'tomcat' }
end

describe file('/etc/systemd/system/tomcat.service') do
  it { should be_file }
  its('content') { should match /Description=Apache Tomcat Web Application Container/ }
end

describe bash('curl http://localhost:8081') do
  its('stderr') { should match /% Total/ }
  its('stdout') { should match /<h1>Apache Tomcat/ }
end

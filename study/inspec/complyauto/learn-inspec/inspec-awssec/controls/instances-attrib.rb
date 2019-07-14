# inspec exec aws-security -t aws://us-east-1 --attrs attributes.yml

webid = attribute('ec2_instance.webserver', description: 'Web Server ID')
imgid = attribute('image_id', description: 'Ubuntu 16.04 AMI ID')
vpcid = attribute('vpc.id', description: 'VPC ID')
snid = attribute('subnet.public.id', description: 'Subnet ID')
sgsshid = attribute('security_group.ssh.id', description: 'Security group ID for SSH')
sgwebid = attribute('security_group.web.id', description: 'Security group ID for HTTP')
sgdbid = attribute('security_group.mysql.id', description: 'Security group ID for MySQL')

describe aws_ec2_instance(webid) do
    it { should be_running }
    its('image_id') { should eq imgid }
    its('instance_type') { should eq 't2.micro' }
    its('vpc_id') { should eq vpcid }
    its('subnet_id') { should eq snid }
    its('security_group_ids') { should include sgsshid }
    its('security_group_ids') { should include sgwebid }
  end

  describe aws_ec2_instance('i-0aaea04aa0b9687c2') do
    it { should be_running }
    its('image_id') { should eq imgid }
    its('instance_type') { should eq 't2.micro' }
    its('public_ip_address') { should_not be }
    its('vpc_id') { should eq vpcid }
    its('subnet_id') { should eq 'subnet-bb778295' }
    its('security_group_ids') { should include sgsshid }
    its('security_group_ids') { should include sgdbid }
  end
  
  describe aws_vpc(vpcid) do
    its('state') { should eq 'available' }
    its('cidr_block') { should eq '10.0.0.0/16' }
  end
  
  describe aws_subnet(snid) do
    it { should exist }
    its('vpc_id') { should eq vpcid }
    its('cidr_block') { should cmp '10.0.1.0/24' }
    its('availability_zone') { should eq 'us-east-1a' }
  end
  
  describe aws_subnet('subnet-bb778295') do
    it { should exist }
    its('vpc_id') { should eq vpcid }
    its('cidr_block') { should cmp '10.0.100.0/24' }
    its('availability_zone') { should eq 'us-east-1a' }
  end
  
  describe aws_security_group(sgsshid) do
    it { should exist }
  end
  
  describe aws_security_group(sgwebid) do
    it { should exist }
  end
  
  describe aws_security_group(sgdbid) do
    it { should exist }
  end
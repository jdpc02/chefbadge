#
# Cookbook:: lcd_web
# Spec:: default
#
# Copyright:: 2017, Student Name, All Rights Reserved.

require 'spec_helper'

describe 'lcd_web::default' do
  context 'CentOS' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs httpd' do
      expect(chef_run).to install_package('httpd')
    end

    it 'installs net-tools' do
      expect(chef_run).to install_package('net-tools')
    end

    it 'enables httpd' do
      expect(chef_run).to enable_service('httpd')
    end

    it 'starts httpd' do
      expect(chef_run).to start_service('httpd')
    end
  end
end

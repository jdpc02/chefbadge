#
# Cookbook:: lcd_web
# Spec:: default
#
# Copyright:: 2017, Student Name, All Rights Reserved.

require 'spec_helper'

describe 'lcd_web::users' do
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

    it 'group creation' do
      expect(chef_run).to create_group('developers')
    end

    it 'user creation' do
      expect(chef_run).to create_user('webadmin').with(group: 'developers')
    end
  end
end

require 'spec_helper'

describe 'ext_ec_nginx_test::default' do
  context 'on CentOS' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'centos',
        version: '7',
        step_into: ['nginx_server']
      ).converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs NGINX' do
      expect(chef_run).to install_package('nginx')
    end

    it 'creates the /var/www/www.example.com/ directory' do
      expect(chef_run).to create_directory('/var/www/www.example.com')
    end

    it 'creates a server file for www.example.com' do
      expect(chef_run).to render_file('/etc/nginx/conf.d/www.example.com.conf')
    end

    it 'deletes the host configuration file' do
      expect(chef_run).to delete_file('/etc/nginx/conf.d/blog.conf')
      expect(chef_run).to delete_file('/etc/nginx/conf.d/status.example.com.conf')
    end

    it 'deletes the static path directory' do
      expect(chef_run).to delete_directory('/var/www/blog')
      expect(chef_run).to delete_directory('/var/www/status')
    end
  end
end

# default['setupmyenv']['packages']['win'] = ['7zip', 'wget', 'putty', 'sysinternals', 'winscp', 'jq', 'git']
# default['setupmyenv']['chefwrk']['win'] = 'https://packages.chef.io/files/stable/chef-workstation/0.4.2/windows/2012r2/chef-workstation-0.4.2-1-x64.msi'
# default['setupmyenv']['chefwrkchk']['win'] = 'eb2c985792010f026dabb9a58749257a2b469a74ab30a42ea56e48d3bbd7c787'
# default['setupmyenv']['packages']['linux'] = ['bindtools', 'jq']

default['setupmyenv'].tap do |myenv|
  myenv['win'].tap do |win|
    win['packages'] = ['7zip', 'wget', 'putty', 'sysinternals', 'winscp', 'jq', 'git']
    win['cwrk'] = 'https://packages.chef.io/files/stable/chef-workstation/0.4.2/windows/2012r2/chef-workstation-0.4.2-1-x64.msi'
    win['cwrkchk'] = 'eb2c985792010f026dabb9a58749257a2b469a74ab30a42ea56e48d3bbd7c787'
  end
  myenv['linux'].tap do |linux|
    linux['rhpkgs'] = ['epel-release', 'bind-utils', 'jq']
    linux['cwrkrh'] = 'https://packages.chef.io/files/stable/chef-workstation/0.4.2/el/7/chef-workstation-0.4.2-1.el6.x86_64.rpm'
    linux['cwrkrhchk'] = '83055fc3418dc041ab540c958d2ff7a9b6e75c59cd9063139df13eb65690ad1a'
  end
end

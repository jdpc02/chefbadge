# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :someprop, String, name_property: true
property :somedisk, String, default: 'newdisk'
property :extsize, Integer, default: 20

default_action :create

action :create do
  cmd = Mixlib::ShellOut.new('ls /sys/class/scsi_host/')
  cmd.run_command
  diskscans = cmd.stdout
  diskscans = diskscans.split("\n")
  diskscans.each do |scandisk|
    execute "disk scan #{scandisk}" do
      command "echo \"- - -\" > /sys/class/scsi_host/#{scandisk}/scan"
      action :run
    end
  end

  ruby_block 'break time' do
    block do
      sleep(30)
    end
    action :run
  end

  cmd = Mixlib::ShellOut.new('lsblk | grep disk | grep sd | awk \'{if ($3 == 0) print $1}\'')
  cmd.run_command
  puts cmd.stdout
  alldisk = cmd.stdout
  alldisk = alldisk.to_s.chomp
  alldisk = alldisk.split("\n")

  package 'e2fsprogs' do
    action :install
  end

  puts alldisk
  alldisk.each do |procdisk|
    cmd = Mixlib::ShellOut.new("file -s /dev/#{procdisk} | grep data --count")
    cmd.run_command
    diskstat = cmd.stdout
    next unless diskstat == 1
    bash 'Create partition' do
      code <<-EOH
        sfdisk /dev/#{procdisk} <<EOF
        0,
        EOF
      EOH
    end

    execute 'Format partition' do
      command "mkfs.ext4 -L #{procdisk} data /dev/#{procdisk}"
    end

    directory "/mnt/#{procdisk}"

    execute 'Add entry to fstab' do
      cwd '/etc'
      command "echo \"/dev/#{procdisk}   /mnt/#{procdisk}      ext4     defaults    1 2\" >> /etc/fstab"
    end

    execute 'Mount disk' do
      command 'mount -a'
    end
  end
end

action :delete do
end

action :extend do
end

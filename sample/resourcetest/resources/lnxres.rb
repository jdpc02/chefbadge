# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :someprop, String, default: 'This is an example property', name_property: true
property :somedisk, String, default: 'newdisk'
property :extsize, Integers, default: 20

default_action :create

action :create do
  diskscans = %x(ls /sys/class/scsi_host/)
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

  package 'e2fsprogs'

  # bash 'process new disks' do
  #   code <<-EOH
  #     alldisks=$(lsblk | grep disk | grep sd | awk '{if ($3 == 0) print $1}')
  #     for procdisk in $alldisks; do
  #       diskstat=$(file -s /dev/$procdisk | grep data --count)
  #       if  [ $diskstat = 1 ]
  #       then
  #         echo "The /dev/$procdisk is being processed"
  #         sfdisk /dev/$procdisk <<EOF
  #         0,
  #         EOF
  #         mkfs.ext4 -L "$procdisk data" /dev/$procdisk
  #         mkdir /mnt/$procdisk

  #       fi
  #     done      
  #   EOH
  #   action :run
  # end
  
  alldisk = %x(lsblk | grep disk | grep sd | awk '{if ($3 == 0) print $1}').to_s.chomp
  alldisk.each do |procdisk|
    diskstat = %x(file -s /dev/#{procdisk} | grep data --count)
    if diskstat == 1
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
        cwd /etc
        command "echo '/dev/#{procdisk}   /mnt/#{procdisk}      ext4     defaults    1 2' >> /etc/fstab"
      end

      execute 'Mount disk' do
        command 'mount -a'
      end
    end
  end
end

action :delete do
end

action :extend do
end

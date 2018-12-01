# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :someprop, String, default: 'This is an example property'
property :somedisk, String, default: 'newdisk'
property :extsize, Integers, default: 20

default_action :create

action :create do
  bash 'name' do
      code <<-EOH
        ls /sys/class/scsi_host/
        echo "- - -" > /sys/class/scsi_host/host0/scan
        echo "- - -" > /sys/class/scsi_host/host1/scan
        echo "- - -" > /sys/class/scsi_host/host2/scan
        ls /sys/class/scsi_device/
        echo 1 > /sys/class/scsi_device/0\:0\:0\:0/device/rescan
        echo 1 > /sys/class/scsi_device/2\:0\:0\:0/device/rescan
      EOH
      action :run
  end
  
end

action :delete do
end

action :extend do
end

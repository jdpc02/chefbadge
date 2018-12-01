# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
property :someprop, String, default: 'This is an example property'
property :somedisk, String, default: 'D'
property :extsize, Integers, default: 20

default_action :create

action :create do
  powershell_script 'Grab New Disks, Initialize and Format' do
      code <<-EOH
        ### Stops the Hardware Detection Service ###
        Stop-Service -Name ShellHWDetection

        ### Grabs all the new RAW disks into a variable ###
        $disk = get-disk | where partitionstyle -eq ‘raw’

        ### Starts a foreach loop that will add the drive
        ### and format the drive for each RAW drive
        ### the OS detects ###
        foreach ($d in $disk){
            $diskNumber = $d.Number
            $dl = get-Disk $d.Number | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize
            Format-Volume -driveletter $dl.Driveletter -FileSystem NTFS -NewFileSystemLabel "OS Disk $diskNumber" -Confirm:$false
            ### 2 Second pause between each disk ###
            ### Initialization, Partitioning, and formatting ###
            Start-Sleep 2
        }
        ### Starts the Hardware Detection Service again ###
        Start-Service -Name ShellHWDetection

        ### end of script ###
      EOH
  end
end

action :delete do
  powershell_script 'Delete partition' do
    code <<-EOH
      $deldisk = new_resource.somedisk
      $deldisk = $deldisk.Trim()
      $deldisk = $deldisk.Substring(0,1)
      Remove-Partition -DriveLetter $deldisk
    EOH
  end
end

action :extend do
  powershell_script 'Extending a disk' do
      code <<-EOH
        $moredisk = new_resource.extsize
        $extdisk = new_resource.somedisk
        $extdisk = $extdisk.Trim()
        $extdisk = $extdisk.Substring(0,1)
        Resize-Partition -DriveLetter $extdisk -Size $moredisk
      EOH
  end
end

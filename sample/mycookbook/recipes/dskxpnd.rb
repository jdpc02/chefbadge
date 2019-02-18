#
# Cookbook:: mycookbook
# Recipe:: dskxpnd
#
# Copyright:: 2019, The Authors, All Rights Reserved.

service 'ShellHWDetection' do
  action :stop
end

powershell_script 'Grab New Disks, Initialize and Format' do
  code <<-EOH
    New-Item -ItemType Directory c:\\mylogs
    $disk = get-disk | where partitionstyle -eq "raw" | tee-object -Append -FilePath "c:\\mylogs\\script.log"

    foreach ($d in $disk) {
      $diskNumber = $d.Number | tee-object -Append -FilePath "c:\\mylogs\\script.log"
      $dl = get-Disk $d.Number | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | tee-object -Append -FilePath "c:\\mylogs\\script.log"
      Format-Volume -driveletter $dl.Driveletter -FileSystem NTFS -NewFileSystemLabel "OS Disk $diskNumber" -Confirm:$false  | tee-object -Append -FilePath "c:\\mylogs\\script.log"
      Start-Sleep 2
    }
    ### end of script ###
  EOH
  not_if '(get-disk | where partitionstyle -eq "raw") -eq $null'
end

service 'ShellHWDetection' do
  action :start
end

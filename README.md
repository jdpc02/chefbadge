# All things Chef


Useful cookbooks as reference under Sample.
- disktest is a custom resource about disks
- lazytest utilized lazy for picking up updated attributes
- resourcetest is a custom resource to setup web servers
- mycookbook calls the custom resources


Utilized the following as a basis for my code.
* [Script to move IIS](https://gallery.technet.microsoft.com/scriptcenter/Script-to-move-the-IIS-f1fb62a5) 


When adding disks for vagrant/virtualbox in .kitchen.yml, you can list the existing disk from a virtualbox VM via:
```
VBoxManage.exe list runningvms
VBoxManage.exe showvminfo <UUID/VM Name>
```
Check the Storage Controller Name as that is needed for creating a new disk.


The different system bus and controller chipsets are as follows:
> [--add ide|sata|scsi|floppy|sas|usb|pcie]
> [--controller LSILogic|LSILogicSAS|BusLogic|
>    IntelAhci|PIIX3|PIIX4|ICH6|I82078|USB|NVMe]

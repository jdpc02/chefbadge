# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html
resource_name :winhttp

property :someprop, String, name_property: true
property :thisurl, String, default: 'mylocalnode.local.loc'

default_action :create

action :create do
  require 'chef/mixin/powershell_out'
  ::Chef::Recipe.send(:include, Chef::Mixin::PowershellOut)

  chkscript = <<-EOH
    $output = (Get-WindowsFeature -Name Web-Server).Installed
    $output
  EOH

  chkoutput = powershell_out(chkscript).stdout

  if chkoutput == False
    platformver = node['platform_version']
    strarr = platformver.split('.')
    vn = strarr[2]

    if vn.to_i >= 9600
      Chef::Log.info 'Running at least Server 2012 R2'
      if Dir.exist? 'D:/'
        logdir = 'd:/inetpub/logs/LogFiles'
      else
        logdir = node['iis']['docroot']
      end

      # unless File.directory? logdir
        powershell_script 'IIS Installation' do
          code <<-EOH
            Import-Module ServerManager
            Add-WindowsFeature Web-Server, Web-Mgmt-Console
          EOH
          # not_if '(Get-WindowsFeature -Name Web-Server).Installed'
        end

        %w(d:\inetpub d:\inetpub\wwwroot d:\inetpub\logs d:\inetpub\logs\LogFiles).each
        do |createdir|
          directory createdir
        end

        powershell_script 'Change Default Log Dir' do
          code <<-EOH
            $newlogdir = #{logdir}
            Import-Module WebAdministration
            Set-WebConfigurationProperty "/system.applicationHost/sites/siteDefaults" -name logfile.directory -value $newlogdir
          EOH
        end
      # end
    end
  else
    puts 'IIS already installed'
  end
end

action :selfsignedcert do
  platformver = node['platform_version']
  strarr = platformver.split('.')
  vn = strarr[2]

  if vn.to_i >= 9600
    Chef::Log.info 'Running at least Server 2012 R2'

    powershell_script 'Clear Expired Self Signed Cert' do
      code <<-EOH
        $ExpirationCheck = $null
        $CurrTime = Get-Date
        $ExpirationCheck = (Get-ChildItem Cert:\\LocalMachine\\My | Where-Object { $_.Subject -like "*#{thisurl}*" } | Select-Object -First 1).NotAfter
        if ( ($ExpirationCheck -ne $null) -and ($CurrTime -ge $ExpirationCheck) ) {
          Import-Module WebAdministration
          Remove-WebBinding -Name "Default Web Site" -Port 443 -Protocol https
          $sscert = Get-ChildItem Cert:\\LocalMachine\\My | Where-Object { $_.Subject -like "*#{thisurl}*" }
          $thetp = $sscert.Thumbprint.ToString()
          Remove-Item -Path Cert:\\LocalMachine\\My\\$thetp -DeleteKey
        }
      EOH
    end

    powershell_script 'Generate Self Signed Cert' do
      code <<-EOH
        New-SelfSignedCertificate -CertStoreLocation Cert:\\LocalMachine\\My -DnsName "*#{thisurl}*"
      EOH
      not_if <<-EOH
        If ( Get-ChildItem Cert:\\LocalMachine\\My | Where-Object { $_.Subject -like "*#{thisurl}*" } ) {
            return $true
        } else {
            return $false
        }
      EOH
    end

    powershell_script 'Assigned New Self Signed Cert' do
      code <<-EOH
        Import-Module WebAdministration
        $newcert = (Get-ChildItem Cert:\\LocalMachine\\My | Where-Object { $_.Subject -like "*#{thisurl}*" } | Select-Object -First 1).Thumbprint
        New-WebBinding -Name "Default Web Site" -Port 443 -Protocol https
        (Get-WebBinding "Default Web Site" -Port 443 -Protocol https).AddSslCertificate($newcert, "MY")
      EOH
      not_if <<-EOH
        If ( Get-WebBinding | Where-Object { $_.bindingInformation -like "*443*" } ) {
            return $true
        } else {
            return $false
        }
      EOH
    end
  end
end

action :letsencryptcert do
end

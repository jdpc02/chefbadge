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

  chkoutput = powershell_out(chkscript).stdout.delete("\n").delete("\r")

  if chkoutput == 'False'
    platformver = node['platform_version']
    strarr = platformver.split('.')
    vn = strarr[2]

    if vn.to_i >= 9600
      Chef::Log.info 'Running at least Server 2012 R2'
      windows_feature_powershell 'Web-Server' do
        # management_tools true
        action :install
      end

      if Dir.exist? 'D:/'
        directory 'D:/inetpub'

        remote_directory 'D:/inetpub' do
          source 'C:/inetpub'
          recursive true
          action :create
        end

        registry_key 'HKLM\\System\\CurrentControlSet\\Services\\WAS\\Parameters' do
          values [{
            name: 'ConfigIsolationPath',
            type: :string,
            data: 'D:\\inetpub\\temp\\appPools'
          }]
          action :create
        end

        %w(HKLM\\Software\\Microsoft\\inetstp HKLM\\Software\\Wow6432Node\\Microsoft\\inetstp).each do |regkey|
          registry_key "#{regkey}" do
            values [{
              name: 'PathWWWRoot',
              type: :expand_string,
              data: 'D:\\inetpub\\wwwroot'
            }]
            ignore_failure true
            action :create
          end

          registry_key "#{regkey}" do
            values [{
              name: 'PathFTPRoot',
              type: :expand_string,
              data: 'D:\\inetpub\\ftproot'
            }]
            ignore_failure true
            action :create
          end
        end

        batch 'Move to D' do
          cwd Chef::Config[:file_cache_path]
          code <<-EOH
          set MOVETO=D:\\
          %windir%\\system32\\inetsrv\\appcmd add backup beforeRootMove
          iisreset /stop
          REM xcopy %systemdrive%\\inetpub %MOVETO%inetpub /O /E /I /Q

          REM reg add HKLM\\System\\CurrentControlSet\\Services\\WAS\\Parameters /v ConfigIsolationPath /t REG_SZ /d %MOVETO%inetpub\\temp\\appPools /f

          %windir%\\system32\\inetsrv\\appcmd set config -section:system.applicationHost/sites -siteDefaults.traceFailedRequestsLogging.directory:"%MOVETO%inetpub\\logs\\FailedReqLogFiles"
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.applicationHost/sites -siteDefaults.logfile.directory:"%MOVETO%inetpub\\logs\\logfiles"
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.applicationHost/log -centralBinaryLogFile.directory:"%MOVETO%inetpub\\logs\\logfiles"
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.applicationHost/log -centralW3CLogFile.directory:"%MOVETO%inetpub\\logs\\logfiles"
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.applicationHost/sites -siteDefaults.ftpServer.logFile.directory:"%MOVETO%inetpub\\logs\\logfiles"
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.ftpServer/log -centralLogFile.directory:"%MOVETO%inetpub\\logs\\logfiles"

          %windir%\\system32\\inetsrv\\appcmd set config -section:system.applicationhost/configHistory -path:%MOVETO%inetpub\\history
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.webServer/asp -cache.disktemplateCacheDirectory:"%MOVETO%inetpub\\temp\\ASP Compiled Templates"
          %windir%\\system32\\inetsrv\\appcmd set config -section:system.webServer/httpCompression -directory:"%MOVETO%inetpub\\temp\\IIS Temporary Compressed Files"
          %windir%\\system32\\inetsrv\\appcmd set vdir "Default Web Site/" -physicalPath:%MOVETO%inetpub\\wwwroot
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='401'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='403'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='404'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='405'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='406'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='412'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='500'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='501'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr
          %windir%\\system32\\inetsrv\\appcmd set config -section:httpErrors /[statusCode='502'].prefixLanguageFilePath:%MOVETO%inetpub\\custerr

          REM reg add HKLM\\Software\\Microsoft\\inetstp /v PathWWWRoot /t REG_SZ /d %MOVETO%inetpub\\wwwroot /f 
          REM reg add HKLM\\Software\\Microsoft\\inetstp /v PathFTPRoot /t REG_SZ /d %MOVETO%inetpub\\ftproot /f

          REM if not "%ProgramFiles(x86)%" == "" reg add HKLM\\Software\\Wow6432Node\\Microsoft\\inetstp /v PathWWWRoot /t REG_EXPAND_SZ /d %MOVETO%inetpub\\wwwroot /f 
          REM if not "%ProgramFiles(x86)%" == "" reg add HKLM\\Software\\Wow6432Node\\Microsoft\\inetstp /v PathFTPRoot /t REG_EXPAND_SZ /d %MOVETO%inetpub\\ftproot /f

          iisreset /start
          EOH
          action :run
        end
      else
        logdir = node['iis']['logroot']
      end
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

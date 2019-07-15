# encoding: utf-8
# copyright: 2018, The Authors

title 'Bluekeep profile'

control 'bluekeep-profile' do
  impact 1.0
  title 'Check for bluekeep issue'
  desc 'Confirm node is protected from the bluekeep vulnerability'

  if os.windows?
    case os.release.split('.')[2].to_i
    when 6003
      script = <<-EOH
        (Get-HotFix -Id "KB4499180") -or (Get-HotFix -Id "KB4499149")
      EOH
  
      describe powershell(script) do
        its('stdout') { should eq "True\r\n" }
        its('stderr') { should eq '' }
      end
    when 7601
      script = <<-EOH
        (Get-HotFix -Id "KB4499175") -or (Get-HotFix -Id "KB4499164")
      EOH
  
      describe powershell(script) do
        its('stdout') { should eq "True\r\n" }
        its('stderr') { should eq '' }
      end
    else
      describe os.release.split('.')[2].to_i do
        it { should be >= 9200 }
      end

      describe registry_key('HKLM\System\CurrentControlSet\Control\Terminal Server') do
        its('fDenyTSConnections') { should eq 0x1 }
      end
    
      describe registry_key('HKLM\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp') do
        its('UserAuthentication') { should eq 0x1 }
      end
    end
  end
end

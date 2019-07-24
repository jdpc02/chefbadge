# InSpec test for recipe setupmyenv::mywin

if os.windows?
  describe os_env('PATH') do
    its('split') { should include ("C:\\ProgramData\\chocolatey\\bin") }
  end
  binlist = ['choco', '7z', 'wget', 'putty', 'procmon', 'winscp', 'jq']
  binlist.each do |exefile|
    describe file("C:\\ProgramData\\chocolatey\\bin\\#{exefile}.exe") do
      it { should exist }
    end
  end
  describe file('C:/Program Files/Git/bin/git.exe') do
    it { should exist }
  end
  describe file('C:/opscode/chef-workstation/bin/start-chefws.ps1') do
    it { should exist }
  end
end

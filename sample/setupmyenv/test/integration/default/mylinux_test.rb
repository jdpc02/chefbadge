# InSpec test for recipe setupmyenv::mylinux

if os.redhat?
  binlist = ['dig', 'jq', 'chef']
  binlist.each do |binfile|
    describe file("/bin/#{binfile}") do
      it { should exist }
    end
  end
end

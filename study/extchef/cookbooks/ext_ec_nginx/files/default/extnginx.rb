Ohai.plugin(:Extnginx) do
  provides 'extnginx/version'

  collect_data :default do
    extnginx(Mash.new)
    extnginx[:version] = shell_out('nginx -v').stderr
  end
end

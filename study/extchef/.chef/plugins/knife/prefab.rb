module Test
  module PrefabOptions
    def self.included(base)
      base.option :directory,
        short: '-D DIRECTORY',
        long: '--directory DIRECTORY',
        boolean: false,
        description: 'The path to your prefabs directory',
        proc: Proc.new { |d| Chef::Config[:knife][:prefab_directory] = d }
    end
    def prefab_directory
      Chef::Config[:knife][:prefab_directory] || "#{ENV['HOME']}/.chef/prefabs"
    end
    def prefab_path_for(name)
      "#{prefab_directory}/#{name}.txt"
    end
    def error(message)
      ui.error(message)
      exit(1)
    end
  end
  class PrefabSave < Chef::Knife
    include PrefabOptions

    banner "knife prefab save NAME QUERY (options)"

    def run
      prefab_name = name_args[0]
      mysearch = name_args[1]

      error("Please provide a prefab name") if !prefab_name
      error("Please provide a query to save") if !mysearch

      FileUtils.mkdir_p(prefab_directory)

      prefab_path = prefab_path_for(prefab_name)
      File.open(prefab_path, 'w') { |file| file.write(mysearch) }
      ui.msg("Saved search to #{prefab_path}")
    end
  end
  class PrefabExec < Chef::Knife
    include PrefabOptions

    banner "knife prefab exec NAME QUERY (options)"

    option :ssh_attribute,
      short: '-a ATTR',
      long: '--attribute ATTR',
      boolean: false,
      description: 'Node attribute to use as SSH host'

    option :ssh_user,
      short: '-u USER',
      long: '--user USER',
      boolean: false,
      description: 'User to use with SSH'

    deps do
       require 'chef/knife/ssh'
    end

    def run
      prefab_name = name_args[0]
      mycmd = name_args[1]

      error("Please provide a prefab name") if !prefab_name
      error("Please provide a command to run") if !mycmd

      prefab_path = prefab_path_for(prefab_name)
      begin
        mysearch = File.read(prefab_path)
      rescue
        error("Can't read the file under specified path")
      end

      ssh = Chef::Knife::Ssh.new
      ssh.ui = ui
      ssh.name_args = [mysearch, mycmd]
      ssh.config[:ssh_attribute] = config[:ssh_attribute] if config[:ssh_attribute]
      ssh.config[:ssh_user] = config[:ssh_user] if config[:ssh_user]
      ssh.run
    end
  end
end

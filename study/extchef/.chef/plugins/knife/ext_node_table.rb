module MyKnifePlugin
  class ExtNodeTable < Chef::Knife
    banner 'knife ext node table [SEARCH] (options)'

    deps do
      require 'chef/search/query'
      require 'terminal-table'
      require 'json'
    end

    option :headers,
      long: '--[no-]headers',
      description: 'Set display of table headers',
      boolean: true,
      default: true

    option :style,
      short: '-s JSON',
      long: '--style JSON',
      description: 'JSON String to set styles for terminal-table',
      proc: Proc.new { |j| JSON.parse(j, symbolize_keys: true) },
      default: {}

    def run
      mysearch = name_args.first ||  'name:*'

      if config[:headers]
        table = Terminal::Table.new(headings:['Name', 'Last Check-In'])
      else
        table = Terminal::Table.new
      end
      table.style = config[:style]
      puts "Hello To The World with #{mysearch}"

      begin
        Chef::Search::Query.new.search('node', mysearch, filter_result: {
          'ohai_time' => ['ohai_time'],
          'name' => ['name'],
        }) do |node|
          chkin = node['ohai_time'] ? Time.at(node['ohai_time']) : nil
          table.add_row([node['name'], chkin])
        end
      rescue
        ui.error("What is #{mysearch}")
        exit 1
      end

      table.rows.length > 0 ? ui.msg(table) : ui.msg("Nothing found using #{mysearch}")
    end
  end
end

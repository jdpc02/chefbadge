require 'chef'
require 'chef/handler'

module ExtEcHandlers
  class JsonLogger < Chef::Handler
    def initialize(log_directory = '/var/log')
      @log_directory = log_directory
    end

    def report
      puts "\nRunning My JsonLogger with file: #{log_file.path}\n"
      log_file.write({
        success: run_status.success?,
        start_time: run_status.start_time,
        node_name: run_status.node.name,
        end_time: run_status.end_time,
      }.to_json + "\n")
      log_file.close()
    end

    def log_file
      file_name = if !run_status.end_time
                    'chef-start.json'
                  elsif run_status.success?
                    'chef-report.json'
                  elsif run_status.failed?
                    'chef-exception.json'
                  end
      ::File.open("#{@log_directory}/#{file_name}", 'a')
    end
  end
end

Chef.event_handler do
  on :resource_skipped do |run_context|
    puts "Skipped resources for #{run_context.node.name}"
  end
  on :ohai_completed do
    puts "\nComplete ohai run!\n"
  end
end

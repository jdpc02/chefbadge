# frozen_string_literal: true

context = ChefCLI::Generator.context
policyfile_path = File.join(context.policyfile_dir, "#{context.new_file_basename}.rb")

template policyfile_path do
  source 'Policyfile.rb.erb'
  helpers(ChefCLI::Generator::TemplateHelper)
end

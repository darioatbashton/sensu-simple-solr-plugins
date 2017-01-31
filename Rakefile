require 'bundler/gem_tasks'

begin
  args = [:spec, :make_bin_executable]
end

desc 'Make all plugins executable'
task :make_bin_executable do
  `chmod -R +x bin/*`
end

task default: args


require 'bundler'  
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks 

RSpec::Core::RakeTask.new(:spec)

desc "Run unit tests"
RSpec::Core::RakeTask.new('spec:unit') { |t| t.pattern = "./spec/unit/**/*_spec.rb" }

desc "Run acceptance tests (requires VBoxManage)"
RSpec::Core::RakeTask.new('spec:acceptance') { |t| t.pattern = "./spec/acceptance/**/*_spec.rb" }

desc "Run acceptance tests (requires VBoxManage)"
RSpec::Core::RakeTask.new('spec:acceptance:fast') do |t|
  t.rspec_opts = "--tag ~slow"
  t.pattern = "./spec/acceptance/**/*_spec.rb"
end

desc 'Default task which runs all specs'
task :default => 'spec:unit'

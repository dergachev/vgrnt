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

desc "Start all VMs required by tests"
task "acceptance:prepare" do
  Dir["spec/acceptance/fixtures/{simple,multivm}"].each do |d|
    # not doing this in parallel / background due to Vagrant bug
    # see https://github.com/mitchellh/vagrant/pull/2484
    Dir.chdir(d) do |d|
      puts "In " + `pwd`
      sh "VAGRANT_NO_PLUGINS=1 vagrant up"
    end
  end
end

desc "Stop all VMs started by tests"
task "acceptance:clean" do
  Dir["spec/acceptance/fixtures/*"].each do |d|
    Dir.chdir(d) do |d|
      Dir[".vagrant/machines/*"].each do |name|
        name = File.basename(name)
        puts "In " + `pwd`
        sh "VAGRANT_NO_PLUGINS=1 vagrant destroy #{name} -f > /dev/null &"
      end
    end
  end
end

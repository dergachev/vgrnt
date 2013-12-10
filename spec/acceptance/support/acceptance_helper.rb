require 'spec_helper'

module AcceptanceExampleGroup
  # Captures and returns stream activity during block.
  # Only supports :stdout and :stdin
  # Note that it fails to capture output of exec or system calls.
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end

  def in_vagrant_env_dir(vagrant_homedir, &block)
    # unless (vagrant_homedir)
    #   vagrant_homedir = './spec/acceptance/fixtures/simple'
    # end
    Dir.chdir( vagrant_homedir, &block)
  end

  def capture_in_vagrant_env(stream=nil, &block)
    capture(stream) { in_vagrant_env &block }
  end

  def vagrant_stderr(&block)
    # stubbing because IO.popen in Vgrnt::Util::Exec prevents stderr from being capturable.
    Vgrnt::Util::Exec.stub(:popen) { |cmd| Vgrnt::Util::Exec.popen3(cmd) }

    capture_in_vagrant_env(:stderr, &block)
  end

  def vagrant_stdout(&block)
    capture_in_vagrant_env(:stdout, &block)
  end

  def delete_in_vagrant_env(file)
    in_vagrant_env { File.delete(file) if File.exists?(file) }
  end

  def in_vagrant_env(&block)
    in_vagrant_env_dir(vagrant_path, &block)
  end

  def vagrant_up(path)
    in_vagrant_env_dir(path) do
      s = Vgrnt::Util::VirtualBox::runningMachines()
      # raise s['default'].inspect
      unless s && s['default'] && s['default'][:state] == 'running'
         `VAGRANT_NO_PLUGINS=1 vagrant up`
      end
    end
  end

  def vagrant_destroy(path)
    in_vagrant_env_dir(path) do
      s = Vgrnt::Util::VirtualBox::runningMachines()
      if s && s['default'] && s['default'] && ([nil, "poweroff"].include? s['default'][:state])
         `VAGRANT_NO_PLUGINS=1 vagrant destroy -f`
      end
    end
  end

end

RSpec.configure do |config|
  config.include AcceptanceExampleGroup, :type => :acceptance, :example_group => {
    :file_path => /\bspec\/acceptance\//
  }
end


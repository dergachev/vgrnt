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

  def delete_in_vagrant_env(file)
    in_vagrant_env { File.delete(file) if File.exists?(file) }
  end

  def vagrant_up
    in_vagrant_env do
      s = Vgrnt::Util::runningMachines()
      # raise s['default'].inspect
      unless s && s['default'] && s['default'][:state] == 'running'
         `vagrant up`
      end
    end
  end

end

RSpec.configure do |config|
  config.include AcceptanceExampleGroup, :type => :acceptance, :example_group => {
    :file_path => /\bspec\/acceptance\//
  }
end


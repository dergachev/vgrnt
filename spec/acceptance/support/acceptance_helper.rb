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

  def capture_in_vagrant_env(stream=nil, &block)
    capture(stream) { in_vagrant_env &block }
  end

  def in_vagrant_env(&block)
    Dir.chdir( vagrant_homedir, &block)
  end

  def delete_in_vagrant_env(file)
    in_vagrant_env { File.delete(file) if File.exists?(file) }
  end
end

RSpec.configure do |config|
  config.include AcceptanceExampleGroup, :type => :acceptance, :example_group => {
    :file_path => /\bspec\/acceptance\//
  }
end


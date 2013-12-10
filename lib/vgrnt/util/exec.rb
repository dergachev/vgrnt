module Vgrnt
  module Util
    module Exec
      # used when wanting pass STDIN without buffering
      def self.popen(command)
        # Using IO.popen is important:
        # - Open3.popen3 ignores STDIN. Backticks buffer stdout. Kernel::exec breaks rspec.
        # - getc instead of gets fixes the 1 line lag.
        IO.popen(command) do |io|
          while c = io.getc do 
            putc c
          end
        end
      end
      
      # used when we want to capture stdout, stderr separately and don't care about buffering on stdin
      def self.popen3(command, logger = Vgrnt::Util::Logger)
        Open3.popen3(command) do |stdin, stdout, stderr|
          logger.stdout stdout.read
          logger.error stderr.read
        end
      end
      
      def self.exec(command)
        raise "NOT IMPLEMENTED"
        # FIXME: stop using exec, it's too hard to test without stubbing
        exec(command)
      end
    end
  end
end

module Vgrnt
  module Util
    class Logger

      def self.stdout(str)
        $stdout.puts str unless str.empty?
      end

      def self.notice(str)
        $stderr.puts str unless str.empty?
      end

      def self.debug(str)
        $stderr.puts str if !str.empty? && ENV['VAGRANT_LOG'] == 'debug'
      end

      def self.error(str)
        # terminal codes for red
        $stderr.puts "\e[31m" + str + "\e[0m" unless str.empty?
      end
    end
  end
end

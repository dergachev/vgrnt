# TODO: test me

$vagrant_config_vms = []

module Vagrant
  def self.configure(*args, &block)
    yield Vgrnt::Util::Vagrantfile::Proxy.new
  end
end

module Vgrnt
  module Util
    module Vagrantfile
      class Proxy
        def define(*args)
          # $stderr.puts "Called define with args (#{args.join(", ")})"
          $vagrant_config_vms << args.first
        end

        def method_missing(name, *args, &block)
          return self
        end
      end

      def self.defined_vms
        # clear any previous value (else tests fail depending on exec order)
        # NOT PARALLEL SAFE (not sure how to do this given static methods)
        $vagrant_config_vms = []
        load('./Vagrantfile')
        # puts $vagrant_config_vms.inspect
        if $vagrant_config_vms.empty?
          $vagrant_config_vms << :default
        end
        return $vagrant_config_vms
      end
    end
  end
end

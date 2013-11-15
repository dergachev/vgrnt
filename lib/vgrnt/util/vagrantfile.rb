module Vgrnt
  module Util
    module Vagrantfile

      def self.defined_vms(path = nil)
        Vagrant.eval_vagrantfile(path)
      end

      module Vagrant
        def self.eval_vagrantfile(path = nil)
          # NOT THREAD SAFE (not sure how to do this given static methods)
          @@vagrant_config_vms = []

          # eval Vagrantfile inside of Vgrnt::Util::Vagrantfile namespace
          module_eval(File.read(path || './Vagrantfile'))

          @@vagrant_config_vms << :default if @@vagrant_config_vms.empty?
          return @@vagrant_config_vms
        end

        def self.configure(*args, &block)
          yield self
        end

        def self.define(*args)
          @@vagrant_config_vms << args.first
        end

        # stub out anything else
        def self.method_missing(*args)
          return self
        end
      end
    end
  end
end

module Vgrnt
  module Util
    module Vagrantfile

      def self.defined_vms(path = nil)
        Vagrant._eval_vagrantfile(path)
      end

      module Vagrant
        def self._remove_named_arguments(source)
          source = source.gsub(/([\s\(,])[a-zA-Z0-9_]+: ?/, '\1')
          return source
        end

        # eval Vagrantfile inside of Vgrnt::Util::Vagrantfile namespace
        def self._eval_vagrantfile(path = nil)
          # NOT THREAD SAFE (not sure how to do this given static methods)
          @@vagrant_config_vms = []

          vgrntfile_source = File.read(path || './Vagrantfile')
          if RUBY_VERSION.to_f <= 1.8
            vgrntfile_source = Vagrant::_remove_named_arguments(vgrntfile_source)
          end
          module_eval(vgrntfile_source)

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

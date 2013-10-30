require 'thor'

module Vgrnt
  class Logger

    def notice(str)
      $stderr.puts str
    end

    def debug(str)
      $stderr.puts str if ENV['VAGRANT_LOG'] == 'debug'
    end

    def error(str)
      $stderr.puts "\e[31m" + str + "\e[0m"  # terminal codes for red
    end
  end

  #  Undoes the automatic removal of -- in Thor::Options.peek. Otherwise "vgrnt ssh precise -- ls /" 
  #  is parsed as "precise ls /". TODO: is there a less hacky way to handle this?
  class ::Thor::Options
    def peek
      return super
    end
  end

  class Util
    def self.getRunningMachines
      machines = {}

      ids = Dir.glob(".vagrant/machines/*/*/id")
      ids.each do |id_file|
        machine_name = id_file[ /^.vagrant\/machines\/(\w+)\/\w+\/id$/ ,1]
        machine_id = IO.read(id_file)
        machine_status = `VBoxManage showvminfo #{machine_id} --machinereadable`

        # Forwarding(0)="ssh,tcp,127.0.0.1,2222,,22"
        # Forwarding(1)="ssh,tcp,,2222,,22"
        ssh_info = machine_status.scan( /^Forwarding\(\d+\)="ssh,tcp,([0-9.]*),([0-9]+),/ ).first

        machines[machine_name] = {
            :id =>  machine_id,
            :ssh_ip => ssh_info[0].empty? ? '127.0.0.1' : ssh_info[0],
            :ssh_port => ssh_info[1],
            :state => machine_status.scan( /^VMState="(.*)"$/ ).first.first   # VMState="running"
        }
      end
      # puts machines.inspect
      return machines
    end
  end

  class App < Thor

    def initialize(*args)
      super(*args)
      @logger = Logger.new
    end

    desc "ssh [vm-name] [-- extra ssh args]", "Runs vagrant ssh without bootstrapping vagrant."
    def ssh(target_vm = 'default', *args)

      # removes --, since it's just a separator
      target_vm = 'default' if (target_vm == '--')
      args.shift if args.first == '--'

      # @logger.debug [target_vm, args].inspect ; exit 0

      if File.exists?(".vgrnt-sshconfig")
        @logger.debug "Using .vgrnt-sshconf"
        ssh_command = "ssh -F .vgrnt-sshconfig #{target_vm} #{args.join(' ')}"
      else 
        @logger.debug ".vgrnt-sshconfig file not found; using VBoxManage to get connection info."
        machine = Util::getRunningMachines()[target_vm]

        if machine && machine[:state] == 'running' 
          # found by running "VAGRANT_LOG=debug vagrant ssh"
          default_ssh_args = [
            "vagrant@#{machine[:ssh_ip]}", 
            "-p", machine[:ssh_port], 
            "-o", "DSAAuthentication=yes", "-o", "LogLevel=FATAL", "-o", "StrictHostKeyChecking=no", 
            "-o", "UserKnownHostsFile=/dev/null", "-o", "IdentitiesOnly=yes", 
            "-i", "~/.vagrant.d/insecure_private_key"
          ]

          ssh_command = "ssh #{default_ssh_args.join(" ")} #{args.join(' ')}"
        else
          @logger.error "Specified target vm (#{target_vm}) not running."
          exit 1
        end
      end

      exec ssh_command
    end

    desc "ssh-config [vm-name]", "Store output of 'vagrant ssh-config' to .vgrnt-sshconfig"
    def ssh_config(target="default")
      output = `vagrant ssh-config #{target}`
      if $? && !output.empty?
        IO.write('.vgrnt-sshconfig', output)
        @logger.notice "Created ./.vgrnt-sshconfig with the following:", output
      else
        @logger.error "Call to 'vagrant ssh-config' failed."
        exit 1
      end
    end

    # desc "provision", "Run vagrant provision like last time"
    # def provision
    #   raise "Not implemented yet. Likely requires creating vagrant-vgrnt."
    # end

    desc "vboxmanage [vm-name] -- <vboxmanage-command> [vboxmanage-args]", "Wrapper on VBoxManage that inserts VM id for you."
    def vboxmanage(target_vm = 'default', *args)

      # removes --, since it's just a separator
      target_vm = 'default' if (target_vm == '--')
      args.shift if args.first == '--'

      # derived as follows: `VBoxManage | sed '1,/Commands/d' | grep '^  [a-z]' | awk '{ print $1; }' | sort -u`
      vboxmanage_commands_all  = %w{
          adoptstate bandwidthctl clonehd clonevm closemedium controlvm
          convertfromraw createhd createvm debugvm dhcpserver discardstate
          export extpack getextradata guestcontrol guestproperty hostonlyif
          import list metrics modifyhd modifyvm registervm setextradata
          setproperty sharedfolder showhdinfo showvminfo snapshot startvm
          storageattach storagectl unregistervm usbfilter}

      # not of form `VBoxManage showvminfo uuid|name ...`
      vboxmanage_commands_special = %w{
          list registervm createvm import export closemedium createhd clonehd
          convertfromraw getextradata setextradata setproperty usbfilter
          sharedfolder guestproperty metrics hostonlyif dhcpserver extpack}

      # of form `VBoxManage showvminfo uuid|name ...`
      vboxmanage_commands_standard = vboxmanage_commands_all - vboxmanage_commands_special
      machine = Util::getRunningMachines()[target_vm]
      if !machine
        @logger.error "The specified target vm (#{target_vm}) has not been started."
        exit 1
      end

      vboxmanage_subcommand = args.shift

      if vboxmanage_commands_standard.include?(vboxmanage_subcommand)
        @logger.debug("Performing UUID insertion for standard vboxmanage command: #{vboxmanage_subcommand}")
        command = (["VBoxManage", vboxmanage_subcommand, machine[:id]] + args).join(" ")
      else
        # TODO: handle substitution for commands like `usbfilter add 0 --target <uuid|name>`

        # @logger.error "Support for non-standard vboxmanage commands (such as #{vboxmanage_subcommand}) is not implemented yet."
        # exit 1

        @logger.debug "Non-standard vboxmanage command detected (#{vboxmanage_subcommand}). Substituting 'VM_ID' for VM id."
        
        # [VM_ID] is an optional literal token which will be replaced by the UUID of the VM referenced by Vagrant
        args.map! { |a| a == 'VM_UUID' ? machine[:id] : a }
        command = (["VBoxManage", vboxmanage_subcommand] + args).join(" ")
      end

      @logger.debug "Executing: #{command}"
      #TODO: windows support (path to VBoxManage.exe")
      exec command
    end
  end
end

# if __FILE__ == $0
#   raise "vgrnt: must be run from vagrant project root" unless File.exists? 'Vagrantfile'
#   Vgrnt::App.start
# end

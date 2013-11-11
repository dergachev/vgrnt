  # TODO testing - stubout VBoxManage showvminfo (use fixtures for its output),
  # then write unit tests for getRunningMachines (consider using erb file for the fixtures)
module Vgrnt
  module Util
    class VirtualBox
      def self.machineSSH(target)
        machine = self.runningMachines()[target]
        return nil unless machine && machine[:state] == 'running'

        # Forwarding(0)="ssh,tcp,127.0.0.1,2222,,22"
        # Forwarding(1)="ssh,tcp,,2222,,22"
        ssh_info = machine[:showvminfo].scan( /^Forwarding\(\d+\)="ssh,tcp,([0-9.]*),([0-9]+),/ ).first

        return {
            :ssh_ip => ssh_info[0].empty? ? '127.0.0.1' : ssh_info[0],
            :ssh_port => ssh_info[1]
        }
      end

      def self.showvminfo_command(machine_id)
        return "VBoxManage showvminfo #{machine_id} --machinereadable"
      end

      def self.showvminfo(machine_id)
        return `#{self.showvminfo_command(machine_id)}`
      end

      def self.runningMachines
        machines = {}

        ids = Dir.glob(".vagrant/machines/*/*/id")
        ids.each do |id_file|
          machine_name = id_file[ /^.vagrant\/machines\/(\w+)\/\w+\/id$/ ,1]
          machine_id = IO.read(id_file)
          
          machine_info = self.showvminfo(machine_id)

          machines[machine_name] = {
              :id =>  machine_id,
              :showvminfo => machine_info,
              :state => machine_info.scan( /^VMState="(.*)"$/ ).first.first   # VMState="running"
          }
        end
        return machines
      end

    end
  end
end

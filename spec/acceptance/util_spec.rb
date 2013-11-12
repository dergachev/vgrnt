require 'acceptance/support/acceptance_helper'

describe "VBoxManage environment" do
  def in_vagrant_env(&block)
    in_vagrant_env_dir './spec/acceptance/fixtures/simple', &block
  end

  before(:all) { vagrant_up }

  it 'ensure we can execute VBoxManage' do
    return_code = system("VBoxManage list vms > /dev/null")
    expect(return_code).to eq true
  end

  it 'ensure vgrnt-test VM is recognized' do
    expect(`VBoxManage list vms`).to include 'vgrnt-test'
  end

  it 'ensure vgrnt-test VM is running' do
    expect(`VBoxManage showvminfo vgrnt-test --machinereadable | grep VMState`).to include '"running"'
  end
end


describe Vgrnt::Util::VirtualBox do

  context "when running from ./spec/acceptance/fixtures/simple" do
    def in_vagrant_env(&block)
      in_vagrant_env_dir './spec/acceptance/fixtures/simple', &block
    end

    before(:all) { vagrant_up }

    describe "::showvminfo" do
      it 'ensure vgrnt-test VM is running' do
        expect(Vgrnt::Util::VirtualBox::showvminfo('vgrnt-test')).to include 'UUID'
      end
    end
    
    describe "::runningMachines" do
      it 'ensure .vgrnt directory exists' do
        expect(in_vagrant_env { File.exists? '.vagrant' }).to be_true
      end

      it 'ensure vgrnt-test VM is running' do
        runningmachines = in_vagrant_env { Vgrnt::Util::VirtualBox::runningMachines() }
        expect(runningmachines['default'][:state]).to eq 'running'
      end
    end

    describe "::machineSSH" do
      let :machine_ssh_info do 
        in_vagrant_env { Vgrnt::Util::VirtualBox::machineSSH('default') }
      end

      it 'extracts SSH hostname' do
        expect(machine_ssh_info[:ssh_ip]).to eq '127.0.0.1'
      end

      it 'extracts SSH port, within the 22xx range' do
        expect(machine_ssh_info[:ssh_port]).to match /^22..$/
      end
    end
  end
end

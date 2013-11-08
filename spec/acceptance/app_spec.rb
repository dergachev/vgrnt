require 'acceptance/support/acceptance_helper'

describe Vgrnt::App do

  context "when running from ./spec/acceptance/fixtures/simple" do
    before(:all) { vagrant_up }

    def in_vagrant_env(&block)
      in_vagrant_env_dir('spec/acceptance/fixtures/simple', &block)
    end

    describe "#ssh" do
      it 'works with default VM specified explicitly' do
        output = capture_in_vagrant_env(:stdout) { Vgrnt::App.start(['ssh', 'default', '--', 'whoami']) }
        expect(output).to eq "vagrant\n"
      end

      it 'works with default VM specified implicitly' do
        output = capture_in_vagrant_env(:stdout) { Vgrnt::App.start(['ssh', '--',  'whoami']) }
        expect(output).to eq "vagrant\n"
      end
    end

    describe "#ssh-config", :slow do

      vagrant_homedir_variable = 'spec/acceptance/fixtures/simple'
      before(:all) { delete_in_vagrant_env '.vgrnt-sshconfig' }
      after(:all) { delete_in_vagrant_env '.vgrnt-sshconfig' }

      it 'with default VM specified explicitly' do
        expect( in_vagrant_env { File.exists? '.vgrnt-sshconfig' } ).to be_false
        stderr = capture_in_vagrant_env(:stderr) { Vgrnt::App.start(['ssh-config', 'default']) }
        expect( in_vagrant_env { File.exists? '.vgrnt-sshconfig' } ).to be_true
      end

      it "works with #ssh" do
        output = capture_in_vagrant_env(:stdout) { Vgrnt::App.start(['ssh', 'default', '--', 'whoami']) }
        expect(output).to eq "vagrant\n"
      end
    end

    describe "#vboxmanage" do
      it "runs displays usage when run with no arguments" do
        output = capture_in_vagrant_env(:stdout) { Vgrnt::App.start(['vboxmanage']) }
        expect(output).to include "Usage:"
      end

      it "runs regular command (showvminfo)" do
        output = capture_in_vagrant_env(:stdout) { Vgrnt::App.start(['vboxmanage', 'default', '--', 'showvminfo']) }
        expect(output).to match /Name.*vgrnt-test/
      end

      it "substitutes VM_UUID in irregular commands (guestproperty enumerate VM_UUID)" do
        output = capture_in_vagrant_env(:stdout) { Vgrnt::App.start(['vboxmanage', 'default', '--', 'guestproperty', 'enumerate', 'VM_UUID']) }
        expect(output).to include "Name: /VirtualBox/GuestInfo/OS/Product"
      end
    end
  end
end

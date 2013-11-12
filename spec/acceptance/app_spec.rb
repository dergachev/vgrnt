require 'acceptance/support/acceptance_helper'

describe Vgrnt::App do

  context "when running from ./spec/acceptance/fixtures/simple" do
    before(:all) { vagrant_up('./spec/acceptance/fixtures/simple') }
    let(:vagrant_path) { './spec/acceptance/fixtures/simple' }

    describe "#ssh" do
      it 'works with default VM specified explicitly' do
        output = vagrant_stdout { Vgrnt::App.start(['ssh', 'default', '--', 'whoami']) }
        expect(output).to eq "vagrant\n"
      end

      it 'works with default VM specified implicitly' do
        output = vagrant_stdout { Vgrnt::App.start(['ssh', '--',  'whoami']) }
        expect(output).to eq "vagrant\n"
      end
    end

    describe "#ssh-config", :slow do

      before(:each) { delete_in_vagrant_env '.vgrnt-sshconfig' }
      after(:each) { delete_in_vagrant_env '.vgrnt-sshconfig' }

      it 'with default VM specified explicitly' do
        expect( in_vagrant_env { File.exists? '.vgrnt-sshconfig' } ).to be_false
        stderr = vagrant_stderr { Vgrnt::App.start(%w{ssh-config default}) }
        expect( in_vagrant_env { File.exists? '.vgrnt-sshconfig' } ).to be_true
      end

      it "works with #ssh" do
        output = vagrant_stdout { Vgrnt::App.start(['ssh', 'default', '--', 'whoami']) }
        expect(output).to eq "vagrant\n"
      end
    end

    describe "#vboxmanage" do
      it "runs displays usage when run with no arguments" do
        output = vagrant_stdout { Vgrnt::App.start(['vboxmanage']) }
        expect(output).to include "Usage:"
      end

      it "runs regular command (showvminfo)" do
        output = vagrant_stdout { Vgrnt::App.start(['vboxmanage', 'default', '--', 'showvminfo']) }
        expect(output).to match /Name.*vgrnt-test/
      end

      it "substitutes VM_UUID in irregular commands (guestproperty enumerate VM_UUID)" do
        output = vagrant_stdout { Vgrnt::App.start(['vboxmanage', 'default', '--', 'guestproperty', 'enumerate', 'VM_UUID']) }
        expect(output).to include "Name: /VirtualBox/GuestInfo/OS/Product"
      end
    end

    describe "#status" do
      it "correctly identifies running machines" do
        # default                   saved (virtualbox)
        output = vagrant_stdout { Vgrnt::App.start(['status']) }
        expect(output).to match /default +running \(virtualbox\)/
      end

      it "is identical to 'vagrant status'", :slow do
        # default                   saved (virtualbox)
        vagrant_output = vagrant_stdout { puts `VAGRANT_NO_PLUGINS=1 vagrant status | grep '(virtualbox)$'` }
        expect(vagrant_output).to match /default +running \(virtualbox\)/

        vgrnt_output = vagrant_stdout { Vgrnt::App.start(['status']) }
        expect(vgrnt_output).to include(vagrant_output)
      end
    end
  end

  context "when running from ./spec/acceptance/fixtures/neveron" do
    before(:all) { vagrant_destroy('./spec/acceptance/fixtures/neveron') }
    let(:vagrant_path) { './spec/acceptance/fixtures/neveron' }

    describe "#status" do
      it "correctly identifies not created machines" do
        # default                   saved (virtualbox)
        output = vagrant_stdout { Vgrnt::App.start(['status']) }
        expect(output).to match /default +not created \(virtualbox\)/
      end

      it "is identical to 'vagrant status'", :slow do
        # default                   saved (virtualbox)
        vagrant_output = vagrant_stdout { puts `VAGRANT_NO_PLUGINS=1 vagrant status | grep '(virtualbox)$'` }
        expect(vagrant_output).to match /default +not created \(virtualbox\)/

        vgrnt_output = vagrant_stdout { Vgrnt::App.start(['status']) }
        expect(vgrnt_output).to include(vagrant_output)
      end
    end
  end
end

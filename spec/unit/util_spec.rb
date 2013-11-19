require "spec_helper"

describe Vgrnt::Util::VirtualBox do
  describe "::showvminfo_command" do
    it "should generate VBoxManage command" do
      expect(Vgrnt::Util::VirtualBox::showvminfo_command("test")).to eq "VBoxManage showvminfo test --machinereadable"
    end
  end
end

describe Vgrnt::Util::Vagrantfile do

  subject { described_class.defined_vms("spec/unit/fixtures/util_vagrantfile/" + vagrantfile) }

  describe "::defined_vms" do
    context "parsing Vagrantfile-simple" do
      let(:vagrantfile) { "Vagrantfile-simple" }
      it { should eq [:default] }
    end

    context "parsing Vagrantfile-multi" do
      let(:vagrantfile) { "Vagrantfile-multi" }
      it { should eq [:vm1, :vm2] }
    end

    context "parsing Vagrantfile-plugins" do
      let(:vagrantfile) { "Vagrantfile-plugins" }
      it { should eq [:default] }
    end

    context "parsing Vagrantfile-misc1" do
      let(:vagrantfile) { "Vagrantfile-misc1" }
      it { should eq [:fake_managed_server, :my_server] }
    end
  end

  describe "Vagrant::_remove_named_arguments" do
    def process(input)
      Vgrnt::Util::Vagrantfile::Vagrant._remove_named_arguments(input)
    end
    it "works with simple named arguments" do
      expect(process 'meth 1, scope: "meh", arg2: "meh"').to eq 'meth 1, "meh", "meh"'
    end
    it "works with space-free named arguments" do
      expect(process 'meth 1, scope:"meh", arg2:"meh"').to eq 'meth 1, "meh", "meh"'
    end
    it "leaves symbols alone" do
      expect(process 'meth :bob, 1, sum(:three)').to eq 'meth :bob, 1, sum(:three)'
    end
  end
end

# describe Vgrnt::Util::Vagrantfile do
# end

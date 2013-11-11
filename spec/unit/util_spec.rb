require 'spec_helper'

# RSpec.configure do |c|
#     c.include Helpers
# end

describe Vgrnt::Util::VirtualBox do
  describe "::showvminfo_command" do
    it 'should generate VBoxManage command' do
      expect(Vgrnt::Util::VirtualBox::showvminfo_command('test')).to eq 'VBoxManage showvminfo test --machinereadable'
    end
  end
end

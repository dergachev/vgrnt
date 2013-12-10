require "spec_helper"

describe Vgrnt::App do
  describe "#np" do
    it 'executes correctly' do
      Vgrnt::Util::Exec.stub(:popen) { |arg| arg }
      output = Vgrnt::App.start(%w{np ssh default -- whoami})
      expect(output).to eq "VAGRANT_NO_PLUGINS=1 vagrant ssh default -- whoami"
    end
  end
end


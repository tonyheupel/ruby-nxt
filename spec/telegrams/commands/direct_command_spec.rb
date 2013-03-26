require './spec/helper'

require './lib/telegrams/commands/direct_command'


describe DirectCommand do
  before do
    @command = DirectCommand.new
  end

  it "must have a command type of 0x00" do
    @command.type.must_equal 0x00
  end

  it "must start out with its type at the first byte" do
    @command.as_bytes[0].must_equal @command.type
  end

  describe "when NOT wanting to wait for a reply" do
    it "must have a first byte of 0x80" do
      no_wait_command = DirectCommand.new false
      no_wait_command.as_bytes[0].must_equal 0x80
    end
  end

  it "must have a readable command property" do
    @command.command
  end

  it "must default command to nil" do
    @command.command.must_be_nil
  end
end


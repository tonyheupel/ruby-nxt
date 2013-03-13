require 'minitest/autorun'

require_relative '../../../lib/telegrams/commands/system_command'


describe SystemCommand do
  before do
    @command = SystemCommand.new
  end

  it "must have a command type of 0x01" do
    @command.type.must_equal 0x01
  end

  it "must start out with its type at the first byte" do
    @command.as_bytes[0].must_equal @command.type
  end

  describe "when NOT wanting to wait for a reply" do
    it "must have a first byte of 0x81" do
      no_wait_command = SystemCommand.new false
      no_wait_command.as_bytes[0].must_equal 0x81
    end
  end
end


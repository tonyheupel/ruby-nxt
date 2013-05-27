require './spec/helper'
require './lib/telegrams/commands/direct/reset_motor_position'

describe ResetMotorPosition do
  before do
    @command = ResetMotorPosition.new
  end

  it "must be a direct command type" do
    @command.type.must_equal DirectCommand.new.type
  end

  it "must have a command of 0x0A" do
    @command.command.must_equal 0x0A
  end

  it "must start out with its type at the first byte" do
    @command.as_bytes[0].must_equal @command.type
  end

  it "must start out with its command at the second byte" do
    @command.as_bytes[1].must_equal @command.command
  end

  describe "when NOT wanting to wait for a reply" do
    it "must have a first byte of 0x80" do
      no_wait_command = ResetMotorPosition.new false
      no_wait_command.as_bytes[0].must_equal 0x80
    end
  end
end

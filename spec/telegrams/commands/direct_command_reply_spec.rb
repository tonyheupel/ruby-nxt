require 'minitest/autorun'

require_relative '../../../lib/telegrams/commands/direct_command_reply'

describe DirectCommandReply do
  describe "when constructing" do
    before do
      @reply = DirectCommandReply.new([0x02, 0x11, 0x00])
    end

    it "must have a command type of 0x02, which is reply" do
      @reply.type.must_equal 0x02
    end

    it "must raise an ArgumentError if the command type is no reply" do
      -> { DirectCommandReply.new([0x11, 0x05, 0x00]) }.must_raise ArgumentError
    end

    it "must raise an ArgumentError if the bytes array isn't at least length of 3" do
      -> { DirectCommandReply.new([0x02]) }.must_raise ArgumentError
    end

    it "must have a command of the command had passed in at byte 1" do
      @reply.command.must_equal 0x11
    end

    it "must have the status code of the reply from byte 2" do
      @reply.status.must_equal 0x00
    end
  end
end

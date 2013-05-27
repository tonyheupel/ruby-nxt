require './spec/helper'
require './lib/telegrams/commands/direct/replies/get_battery_level_reply'

describe GetBatteryLevelReply do
  describe "when creating the reply" do
    before do
      @millivolts = 4100

      # null pad out to max length and convert to ASCIIZ bytes
      @millivolts_bytes = [@millivolts.to_s(16).rjust(4, "0")].pack("H*").bytes.to_a.reverse
      @reply_bytes = [2, 0x0B, 0].concat(@millivolts_bytes)
    end

    it "must parse the millivolts into the message member" do
      reply = GetBatteryLevelReply.new(@reply_bytes)

      reply.message.must_equal @millivolts
    end

    it "must allow access to the message through the millivolts member" do
      reply = GetBatteryLevelReply.new(@reply_bytes)

      reply.millivolts.must_equal @millivolts
    end

    it "must convert the millivolts to volts through the volts member" do
      reply = GetBatteryLevelReply.new(@reply_bytes)

      reply.volts.must_equal @millivolts/1000.0
    end

    it "must raise an ArgumentError if the reply is not for GetBatteryLevel" do
      reply_bytes = [2, 0x01, 0].concat(@millivolts_bytes)

      -> { reply = GetBatteryLevelReply.new(reply_bytes) }.must_raise ArgumentError
    end
  end


end

require './spec/helper'
require './lib/telegrams/commands/direct/replies/keep_alive_reply'

describe KeepAliveReply do
  describe "when creating the reply" do
    before do
      @keep_alive_milliseconds = 4100

      # null pad out to max length and convert to ASCIIZ bytes
      @keep_alive_milliseconds_bytes = [@keep_alive_milliseconds.to_s(16).rjust(4, "0")].pack("H*").bytes.to_a.reverse
      @reply_bytes = [2, 0x0D, 0].concat(@keep_alive_milliseconds_bytes)
    end

    it "must parse the milliseconds into the message member" do
      reply = KeepAliveReply.new(@reply_bytes)

      reply.message.must_equal @keep_alive_milliseconds
    end

    it "must allow access to the message through the milliseconds member" do
      reply = KeepAliveReply.new(@reply_bytes)

      reply.milliseconds.must_equal @keep_alive_milliseconds
    end

    it "must convert the milliseconds to seconds through the seconds member" do
      reply = KeepAliveReply.new(@reply_bytes)

      reply.seconds.must_equal @keep_alive_milliseconds/1000.0
    end

    it "must raise an ArgumentError if the reply is not for KeepAlive" do
      reply_bytes = [2, 0x01, 0].concat(@keep_alive_milliseconds_bytes)

      -> { reply = KeepAliveReply.new(reply_bytes) }.must_raise ArgumentError
    end
  end


end

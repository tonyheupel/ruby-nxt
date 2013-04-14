require './spec/helper'
require './lib/telegrams/commands/direct/replies/get_current_program_name_reply'

describe GetCurrentProgramNameReply do
  describe "when creating the reply" do
    before do
      @filename = "foobar.rxe"

      # null pad out to max length and convert to ASCIIZ bytes
      @filename_bytes = @filename.ljust(20, "\0").unpack('C*')
      @reply_bytes = [2, 0x11, 0].concat(@filename_bytes)
    end

    it "must parse the filename into the message member" do
      reply = GetCurrentProgramNameReply.new(@reply_bytes)

      reply.message.must_equal @filename
    end

    it "must allow access to the message through the program_name member" do
      reply = GetCurrentProgramNameReply.new(@reply_bytes)

      reply.program_name.must_equal @filename
    end

    it "must raise an ArgumentError if the reply is not for GetCurrentProgramName" do
      reply_bytes = [2, 0x01, 0].concat(@filename_bytes)

      -> { reply = GetCurrentProgramNameReply.new(reply_bytes) }.must_raise ArgumentError
    end
  end

end

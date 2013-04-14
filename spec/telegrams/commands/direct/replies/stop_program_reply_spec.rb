require './spec/helper'
require './lib/telegrams/commands/direct/replies/stop_program_reply'

describe StopProgramReply do
  it "must have a reply type" do
    StopProgramReply.new([0x02, 0x01, 0x00]).type.must_equal 0x02
  end

  it "must raise an ArgumentError when the reply is not for a stop_program message" do
    -> { StopProgramReply.new([0x02, 0x9A, 0x00]) }.must_raise ArgumentError
  end

end

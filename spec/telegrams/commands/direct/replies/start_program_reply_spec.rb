require './spec/helper'
require './lib/telegrams/commands/direct/replies/start_program_reply'

describe StartProgramReply do
  it "must have a reply type" do
    StartProgramReply.new([0x02, 0x00, 0x00]).type.must_equal 0x02
  end

  it "must raise an ArgumentError when the reply is not for a start_program message" do
    -> { StartProgramReply.new([0x02, 0x9A, 0x00]) }.must_raise ArgumentError
  end
end

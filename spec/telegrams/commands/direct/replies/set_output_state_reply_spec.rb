require './spec/helper'
require './lib/telegrams/commands/direct/replies/set_output_state_reply'

describe SetOutputStateReply do
  it "must 5ave a reply type" do
    SetOutputStateReply.new([0x02, 0x04, 0x00]).type.must_equal 0x02
  end

  it "must raise an ArgumentError when the reply is not for a set_input_mode message" do
    -> { SetOutputStateReply.new([0x02, 0xFF, 0x00]) }.must_raise ArgumentError
  end
end

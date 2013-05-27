require './spec/helper'
require './lib/telegrams/commands/direct/replies/reset_motor_position_reply'

describe ResetMotorPositionReply do
  it "must have a reply type" do
    ResetMotorPositionReply.new([0x02, 0x0A, 0x00]).type.must_equal 0x02
  end

  it "must raise an ArgumentError when the reply is not for a reset_motor_position message" do
    -> { ResetMotorPositionReply.new([0x02, 0x9A, 0x00]) }.must_raise ArgumentError
  end

end

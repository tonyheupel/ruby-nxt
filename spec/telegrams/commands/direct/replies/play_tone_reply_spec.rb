require './spec/helper'
require './lib/telegrams/commands/direct/replies/play_tone_reply.rb'

describe PlayToneReply do
  it "must support a reply for the PlayTone command" do
    PlayToneReply.new([0x02, 0x03, 0x00]).success?.must_equal true
    PlayToneReply.new([0x02, 0x03, 0x01]).success?.must_equal false
  end

  it "must raise an ArgumentError when the reply is not for the PlayTone command" do
    -> { PlayToneReply.new([0x02, 0x00, 0x00]) }.must_raise ArgumentError
  end

end

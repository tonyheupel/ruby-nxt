require './spec/helper'
require './lib/telegrams/no_message_reply'

describe NoMessageReply do
  it "should accept the bytes as the argument to the constructor" do
    NoMessageReply.new([0x02, 0x11, 0x00]).type.must_equal 0x02
  end

  it "should return an empty string, even if the message bytes are present" do
    NoMessageReply.new([0x02, 0x11, 0x00, 0x01, 0x02]).message.must_equal ''
  end
end

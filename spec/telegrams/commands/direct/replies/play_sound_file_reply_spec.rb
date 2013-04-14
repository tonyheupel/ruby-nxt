require './spec/helper'
require './lib/telegrams/commands/direct/replies/play_sound_file_reply'

describe PlaySoundFileReply do
  it "must have a reply type" do
    PlaySoundFileReply.new([0x02, 0x02, 0x00]).type.must_equal 0x02
  end

  it "must raise an ArgumentError when the reply is not for a play_sound_file message" do
    -> { PlaySoundFileReply.new([0x02, 0x9A, 0x00]) }.must_raise ArgumentError
  end

end

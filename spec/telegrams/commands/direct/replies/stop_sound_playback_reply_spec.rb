require './spec/helper'
require './lib/telegrams/commands/direct/replies/stop_sound_playback_reply'

describe StopSoundPlaybackReply do
  it "must have a reply type" do
    StopSoundPlaybackReply.new([0x02, 0x0C, 0x00]).type.must_equal 0x02
  end

  it "must raise an ArgumentError when the reply is not for a stop_sound_playback message" do
    -> { StopSoundPlaybackReply.new([0x02, 0x9A, 0x00]) }.must_raise ArgumentError
  end

end

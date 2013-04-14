require_relative '../../direct_command_reply'

class StopSoundPlaybackReply < DirectCommandReply
  def initialize(bytes)
    super(bytes)
  end

  # override
  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "must be a reply for a StopSoundPlayback command" unless bytes[1] == 0x0C
  end
end

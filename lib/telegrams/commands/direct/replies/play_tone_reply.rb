require_relative '../../direct_command_reply'

class PlayToneReply < DirectCommandReply
  def initialize(bytes)
    super(bytes)
  end


  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "must be a reply for the PlayTone command" unless bytes[1] == 0x03
  end

end

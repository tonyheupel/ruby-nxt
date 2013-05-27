require_relative '../../direct_command_reply'

class ResetMotorPositionReply < DirectCommandReply
  def initialize(bytes)
    super(bytes)
  end

  # override
  def validate_bytes(bytes)
    super(bytes)
    raise ArgumentError, "must be a reply for a ResetMotorPosition command" unless bytes[1] == 0x0A
  end
end
